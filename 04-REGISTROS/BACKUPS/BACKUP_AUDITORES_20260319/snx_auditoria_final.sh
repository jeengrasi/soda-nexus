#!/data/data/com.termux/files/usr/bin/bash
set -e

BASE="$HOME/soda"
MEM="$BASE/01-MEMORIA/ACTUAL"
LOG="$BASE/04-REGISTROS/SYSTEM"
OUT="$BASE/05-DOCUMENTACION/INFORMES"

mkdir -p "$LOG" "$OUT"

LOGFILE="$LOG/auditoria_final.log"
REPORTE="$OUT/INFORME-AUDITORIA-FINAL.md"

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] [AUDITORIA] $1" | tee -a "$LOGFILE"
}

log "INICIO AUDITORIA FINAL"

for m in 00-GOBIERNO 01-MEMORIA 02-SISTEMA 03-OPERACIONES 04-REGISTROS 05-DOCUMENTACION 06-MONITOR; do
  [ -f "$MEM/estado_${m}.json" ] && log "OK estado_${m}.json" || log "ERROR: falta estado_${m}.json"
done

for m in 00-GOBIERNO 01-MEMORIA 02-SISTEMA 03-OPERACIONES 04-REGISTROS 05-DOCUMENTACION 06-MONITOR; do
  [ -f "$MEM/engranaje_${m}.json" ] && log "OK engranaje_${m}.json" || log "ERROR: falta engranaje_${m}.json"
done

for m in 00-GOBIERNO 01-MEMORIA 02-SISTEMA 03-OPERACIONES 04-REGISTROS 05-DOCUMENTACION 06-MONITOR; do
  [ -f "$MEM/sync_${m}.json" ] && log "OK sync_${m}.json" || log "ERROR: falta sync_${m}.json"
done

{
  echo "# INFORME DE AUDITORÍA FINAL"
  echo "Fecha: $(date)"
  echo "## Estados ministeriales"
  ls -1 "$MEM"/estado_*.json
  echo "## Engranajes"
  ls -1 "$MEM"/engranaje_*.json
  echo "## Sync"
  ls -1 "$MEM"/sync_*.json
} > "$REPORTE"

log "Auditoría final completada"
log "Informe generado: $REPORTE"
