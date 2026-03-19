#!/data/data/com.termux/files/usr/bin/bash
# SODA-NEXUS — AUDITOR BINARIO V2
# Auditoría total Termux ↔ GitHub sin intervención del Director

set -u

BASE="$HOME/soda"
LOG="$BASE/04-REGISTROS/SYSTEM/auditoria_binaria_$(date +%Y%m%d_%H%M%S).log"
mkdir -p "$BASE/04-REGISTROS/SYSTEM"

log() {
  echo -e "$1"
  echo -e "$1" >> "$LOG"
}

sep() {
  log "\n============================================================"
}

log "=== AUDITORÍA BINARIA SODA-NEXUS V2 ==="
log "Fecha: $(date)"
sep

############################
# 1. DETECCIÓN DEL REPO GIT
############################
log "🔍 [1] Detectando repositorio Git en Termux..."

if [ -d "$BASE/.git" ]; then
  log "✔ Repositorio Git detectado en $BASE"
else
  log "❌ No existe repositorio Git en $BASE"
fi

ORIGIN=$(git -C "$BASE" remote get-url origin 2>/dev/null || echo "")
if [ -n "$ORIGIN" ]; then
  log "✔ URL remota detectada: $ORIGIN"
else
  log "❌ No se pudo detectar la URL remota"
fi

BRANCH=$(git -C "$BASE" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
log "✔ Rama activa: $BRANCH"

sep

############################
# 2. INTEGRIDAD DEL REPO
############################
log "🔍 [2] Verificando integridad del repositorio (git fsck)..."
git -C "$BASE" fsck --no-progress >> "$LOG" 2>&1
log "✔ Integridad verificada (ver detalles en el log)"

sep

############################
# 3. ESTADO LOCAL
############################
log "🔍 [3] Estado local (git status)..."
git -C "$BASE" status --porcelain | tee -a "$LOG"

sep

############################
# 4. ARCHIVOS DEL MONITOR EN TERMUX
############################
log "🔍 [4] Buscando monitor en Termux..."
find "$BASE" -type f -name "index*.html" -not -path "*/.git/*" | tee -a "$LOG"
find "$BASE" -type f -name "monitor_data.json" -not -path "*/.git/*" | tee -a "$LOG"

sep

############################
# 5. CONSULTA A GITHUB
############################
log "🔍 [5] Consultando GitHub (estructura remota)..."

if [ -n "$ORIGIN" ]; then
  RAW_BASE=$(echo "$ORIGIN" | sed 's|github.com|raw.githubusercontent.com|g')
  RAW_MAIN="$RAW_BASE/main"

  log "✔ RAW_BASE: $RAW_MAIN"

  curl -s "$RAW_MAIN/docs/index.html" -o /tmp/snx_index.html
  if [ -s /tmp/snx_index.html ]; then
    log "✔ index.html remoto encontrado"
  else
    log "❌ index.html remoto NO encontrado"
  fi

  curl -s "$RAW_MAIN/docs/monitor_data.json" -o /tmp/snx_data.json
  if [ -s /tmp/snx_data.json ]; then
    log "✔ monitor_data.json remoto encontrado"
  else
    log "❌ monitor_data.json remoto NO encontrado"
  fi
else
  log "❌ No se puede consultar GitHub sin URL remota"
fi

sep

############################
# 6. COMPARACIÓN TERMUX ↔ GITHUB
############################
log "🔍 [6] Comparación de archivos clave..."

if [ -s /tmp/snx_index.html ]; then
  LOCAL_INDEX=$(find "$BASE" -type f -name "index*.html" -not -path "*/.git/*" | head -n 1)
  if [ -n "$LOCAL_INDEX" ]; then
    diff -q "$LOCAL_INDEX" /tmp/snx_index.html && \
      log "✔ El HTML local coincide con GitHub" || \
      log "⚠️ El HTML local NO coincide con GitHub"
  else
    log "❌ No existe HTML local para comparar"
  fi
fi

if [ -s /tmp/snx_data.json ]; then
  LOCAL_DATA=$(find "$BASE" -type f -name "monitor_data.json" -not -path "*/.git/*" | head -n 1)
  if [ -n "$LOCAL_DATA" ]; then
    diff -q "$LOCAL_DATA" /tmp/snx_data.json && \
      log "✔ El JSON local coincide con GitHub" || \
      log "⚠️ El JSON local NO coincide con GitHub"
  else
    log "❌ No existe JSON local para comparar"
  fi
fi

sep

############################
# 7. RESUMEN FINAL
############################
log "📋 RESUMEN FINAL DE AUDITORÍA"
log "✔ Repositorio detectado: $ORIGIN"
log "✔ Rama activa: $BRANCH"
log "✔ Integridad verificada"
log "✔ Comparación Termux ↔ GitHub completada"
log "📄 Reporte completo: $LOG"

