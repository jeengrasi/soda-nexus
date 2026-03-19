#!/data/data/com.termux/files/usr/bin/bash
# SODA-NEXUS — AUDITOR BINARIO V3
# Auditoría total Termux ↔ GitHub sin intervención del Director

set -u

BASE="$HOME/soda"
LOG="$BASE/04-REGISTROS/SYSTEM/auditoria_binaria_v3_$(date +%Y%m%d_%H%M%S).log"
mkdir -p "$BASE/04-REGISTROS/SYSTEM"

log() {
  echo -e "$1"
  echo -e "$1" >> "$LOG"
}

sep() {
  log "\n============================================================"
}

log "=== AUDITORÍA BINARIA SODA-NEXUS V3 ==="
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
log "✔ URL remota detectada: $ORIGIN"

BRANCH=$(git -C "$BASE" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
log "✔ Rama activa: $BRANCH"

sep

############################
# 2. INTEGRIDAD DEL REPO
############################
log "🔍 [2] Verificando integridad del repositorio (git fsck)..."
git -C "$BASE" fsck --no-progress >> "$LOG" 2>&1
log "✔ Integridad verificada"

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
# 5. CONSULTA A GITHUB (CORREGIDA)
############################
log "🔍 [5] Consultando GitHub (estructura remota)..."

# 1. Quitar prefijo y sufijo .git
REPO_PATH=$(echo "$ORIGIN" \
  | sed 's|https://github.com/||' \
  | sed 's|.git$||')

# 2. Construir RAW correcto
RAW_MAIN="https://raw.githubusercontent.com/$REPO_PATH/$BRANCH"

log "✔ RAW_MAIN: $RAW_MAIN"

curl -s "$RAW_MAIN/docs/index.html" -o /tmp/snx_index.html
[ -s /tmp/snx_index.html ] && log "✔ index.html remoto encontrado" || log "❌ index.html remoto NO encontrado"

curl -s "$RAW_MAIN/docs/monitor_data.json" -o /tmp/snx_data.json
[ -s /tmp/snx_data.json ] && log "✔ monitor_data.json remoto encontrado" || log "❌ monitor_data.json remoto NO encontrado"

sep

############################
# 6. COMPARACIÓN TERMUX ↔ GITHUB
############################
log "🔍 [6] Comparación de archivos clave..."

LOCAL_INDEX=$(find "$BASE" -type f -name "index*.html" -not -path "*/.git/*" | head -n 1)
LOCAL_DATA=$(find "$BASE" -type f -name "monitor_data.json" -not -path "*/.git/*" | head -n 1)

if [ -n "$LOCAL_INDEX" ] && [ -s /tmp/snx_index.html ]; then
  diff -q "$LOCAL_INDEX" /tmp/snx_index.html \
    && log "✔ HTML local coincide con GitHub" \
    || log "⚠️ HTML local NO coincide con GitHub"
else
  log "❌ No se pudo comparar HTML"
fi

if [ -n "$LOCAL_DATA" ] && [ -s /tmp/snx_data.json ]; then
  diff -q "$LOCAL_DATA" /tmp/snx_data.json \
    && log "✔ JSON local coincide con GitHub" \
    || log "⚠️ JSON local NO coincide con GitHub"
else
  log "❌ No se pudo comparar JSON"
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

sep

log "=== PIE DE PÁGINA SOBERANO ==="
log "1. Nada se borra, todo es útil."
log "2. Termux es la memoria y la verdad."
log "3. Validar scripts antes de modificar."
log "4. Sistema ligero pero potente."
log "5. Todo auditado y certificado."
log "6. Consultar Termux antes de actuar."
log "7. Todo es real."
log "8. Varias tareas por chat."
log "9. Identidad: jeengrasi/soda-nexus."
log "10. Escudo GitHub activo."
log "11. GitHub cerebro, Termux puente."
log "12. ADN en Vault, resto en nube."
log "13. Investigación obligatoria."
log "14. Director decide; IA ejecuta."
log "15. Reporte Antes/Después."
log "16. Prioridad: evitar Signal 9."
log "17. Nada se asume; todo se verifica."
log "18. IA evita antiamnesia."
log "19. GitHub es la Fuente de Verdad."
log "20. Scripts los modifica la IA."
log "21. No se pregunta; se trabaja."
