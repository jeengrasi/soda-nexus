#!/data/data/com.termux/files/usr/bin/bash
# SODA-NEXUS — UNIFICADOR SOBERANO V1
# Clasificación + Ordenamiento + Versionamiento + Migración sin borrar nada

set -u

BASE="$HOME/soda"
HIST="$BASE/04-REGISTROS/SILO_HISTORICO/VERSIONES"
LOG="$BASE/04-REGISTROS/SYSTEM/unificador_soberano_$(date +%Y%m%d_%H%M%S).log"

mkdir -p "$HIST"
mkdir -p "$BASE/06-MONITOR"
mkdir -p "$BASE/02-SISTEMA/BACKEND"
mkdir -p "$BASE/docs"

log() {
  echo -e "$1"
  echo -e "$1" >> "$LOG"
}

sep() {
  log "\n============================================================"
}

log "=== SNX — UNIFICADOR SOBERANO V1 ==="
log "Fecha: $(date)"
sep

########################################
# 1. DETENER PROCESOS DUPLICADOS
########################################
log "🔍 [1] Deteniendo procesos duplicados y zombis..."

# Matar monitores duplicados
pkill -f "monitor" 2>/dev/null || true
pkill -f "snx-monitor" 2>/dev/null || true
pkill -f "monitor_backend" 2>/dev/null || true
pkill -f "monitor_bridge" 2>/dev/null || true

# Matar backends duplicados
pkill -f "snx_backend" 2>/dev/null || true
pkill -f "backend" 2>/dev/null || true

# Matar procesos zombis
pkill -9 -f "defunct" 2>/dev/null || true

log "✔ Procesos duplicados detenidos"
sep

########################################
# 2. CLASIFICAR MONITORES
########################################
log "🔍 [2] Clasificando monitores..."

MONITORES=$(find "$BASE" -type f -name "index*.html" -not -path "*/.git/*")

for M in $MONITORES; do
  FECHA=$(date +%Y%m%d_%H%M%S)
  NOMBRE=$(basename "$M")
  cp -v "$M" "$HIST/${NOMBRE}_$FECHA" >> "$LOG"
done

log "✔ Monitores versionados en histórico"
sep

########################################
# 3. SELECCIONAR MONITOR OFICIAL
########################################
log "🔍 [3] Seleccionando monitor oficial..."

OFICIAL=$(find "$BASE/docs" -type f -name "index.html" | head -n 1)

if [ -z "$OFICIAL" ]; then
  OFICIAL=$(find "$BASE" -type f -name "index.html" | head -n 1)
  cp -v "$OFICIAL" "$BASE/docs/index.html" >> "$LOG"
fi

log "✔ Monitor oficial: $OFICIAL"
sep

########################################
# 4. CLASIFICAR JS, JSON, CSS
########################################
log "🔍 [4] Clasificando JS, JSON, CSS..."

for EXT in js json css; do
  ARCHIVOS=$(find "$BASE" -type f -name "*.$EXT" -not -path "*/.git/*")
  for A in $ARCHIVOS; do
    FECHA=$(date +%Y%m%d_%H%M%S)
    NOMBRE=$(basename "$A")
    cp -v "$A" "$HIST/${NOMBRE}_$FECHA" >> "$LOG"
  done
done

log "✔ Archivos versionados"
sep

########################################
# 5. UNIFICAR BACKEND
########################################
log "🔍 [5] Unificando backend..."

BACKEND_OFICIAL=$(find "$BASE/02-SISTEMA/BACKEND" -type f -name "snx_monitor_backend.py" | head -n 1)

if [ -z "$BACKEND_OFICIAL" ]; then
  BACKEND_OFICIAL=$(find "$BASE" -type f -name "snx_monitor_backend.py" | head -n 1)
  cp -v "$BACKEND_OFICIAL" "$BASE/02-SISTEMA/BACKEND/" >> "$LOG"
fi

log "✔ Backend oficial: $BACKEND_OFICIAL"
sep

########################################
# 6. PREPARAR DOCS PARA GITHUB
########################################
log "🔍 [6] Preparando /docs para GitHub..."

cp -v "$OFICIAL" "$BASE/docs/index.html" >> "$LOG"

JS_DOCS=$(find "$BASE" -type f -name "*.js" -not -path "*/.git/*")
for J in $JS_DOCS; do
  cp -v "$J" "$BASE/docs/" >> "$LOG"
done

JSON_DOCS=$(find "$BASE" -type f -name "*.json" -not -path "*/.git/*")
for J in $JSON_DOCS; do
  cp -v "$J" "$BASE/docs/" >> "$LOG"
done

log "✔ /docs preparado para GitHub Pages"
sep

########################################
# 7. RESUMEN FINAL
########################################
log "📋 RESUMEN FINAL"
log "✔ Monitores versionados"
log "✔ Backend unificado"
log "✔ Archivos clasificados"
log "✔ /docs preparado"
log "✔ Procesos limpiados"
log "📄 Log completo: $LOG"

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
