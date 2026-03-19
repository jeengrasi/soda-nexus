#!/data/data/com.termux/files/usr/bin/bash
set -e

BASE="$HOME/soda"
MEM="$BASE/01-MEMORIA/ACTUAL"
LOG="$BASE/04-REGISTROS/SYSTEM"
OUT="$BASE/05-DOCUMENTACION/CERTIFICACION"

mkdir -p "$LOG" "$OUT"

LOGFILE="$LOG/validacion_certificada.log"
REPORTE="$OUT/INFORME-CERTIFICACION-SISTEMA.md"

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] [CERTIFICACION] $1" | tee -a "$LOGFILE"
}

log "INICIO VALIDACION CERTIFICADA DEL SISTEMA"

# ============================================================
# 1. PRUEBA DEL CENTRAL
# ============================================================
log "Ejecutando CENTRAL..."
$BASE/02-SISTEMA/GLOBAL/snx_ia_central.sh >> "$LOGFILE" 2>&1
log "CENTRAL ejecutado correctamente"

# ============================================================
# 2. PRUEBA DE ESTADOS
# ============================================================
log "Validando estados..."
for m in 00-GOBIERNO 01-MEMORIA 02-SISTEMA 03-OPERACIONES 04-REGISTROS 05-DOCUMENTACION 06-MONITOR; do
  if [ -f "$MEM/estado_${m}.json" ]; then
    log "OK estado_${m}.json"
  else
    log "ERROR: falta estado_${m}.json"
  fi
done

# ============================================================
# 3. PRUEBA DE ENGRANAJES
# ============================================================
log "Validando engranajes..."
for m in 00-GOBIERNO 01-MEMORIA 02-SISTEMA 03-OPERACIONES 04-REGISTROS 05-DOCUMENTACION 06-MONITOR; do
  if [ -f "$MEM/engranaje_${m}.json" ]; then
    log "OK engranaje_${m}.json"
  else
    log "ERROR: falta engranaje_${m}.json"
  fi
done

# ============================================================
# 4. PRUEBA DE SYNC
# ============================================================
log "Validando sincronización..."
for m in 00-GOBIERNO 01-MEMORIA 02-SISTEMA 03-OPERACIONES 04-REGISTROS 05-DOCUMENTACION 06-MONITOR; do
  if [ -f "$MEM/sync_${m}.json" ]; then
    log "OK sync_${m}.json"
  else
    log "ERROR: falta sync_${m}.json"
  fi
done

# ============================================================
# 5. PRUEBA DE INTEGRIDAD (HASHES)
# ============================================================
log "Validando integridad..."
HASHDIR="$MEM/HASHES"
for h in "$HASHDIR"/*.sha; do
  script=$(basename "$h" | sed 's/.sha//')
  case "$script" in
    00_GOBIERNO_snx_ia_gobierno.sh) target="$BASE/00-GOBIERNO/snx_ia_gobierno.sh" ;;
    01_MEMORIA_snx_ia_memoria.sh) target="$BASE/01-MEMORIA/snx_ia_memoria.sh" ;;
    02_SISTEMA_snx_ia_sistema.sh) target="$BASE/02-SISTEMA/snx_ia_sistema.sh" ;;
    02_SISTEMA_GLOBAL_snx_ia_central.sh) target="$BASE/02-SISTEMA/GLOBAL/snx_ia_central.sh" ;;
    03_OPERACIONES_snx_ia_operaciones.sh) target="$BASE/03-OPERACIONES/snx_ia_operaciones.sh" ;;
    04_REGISTROS_snx_ia_registros.sh) target="$BASE/04-REGISTROS/snx_ia_registros.sh" ;;
    05_DOCUMENTACION_snx_ia_documentacion.sh) target="$BASE/05-DOCUMENTACION/snx_ia_documentacion.sh" ;;
    06_MONITOR_snx_ia_monitor.sh) target="$BASE/06-MONITOR/snx_ia_monitor.sh" ;;
  esac

  if [ -f "$target" ]; then
    hash_actual=$(sha256sum "$target" | awk '{print $1}')
    hash_prev=$(cat "$h")
    if [ "$hash_actual" = "$hash_prev" ]; then
      log "OK HASH: $script"
    else
      log "ERROR HASH: $script"
    fi
  else
    log "ERROR: archivo no encontrado para $script"
  fi
done

# ============================================================
# 6. PRUEBA DE ESTRUCTURA
# ============================================================
log "Validando estructura..."
tree "$BASE" >> "$LOGFILE" 2>&1 || log "tree no disponible"

# ============================================================
# 7. PRUEBA DE ANTIAMNESIA
# ============================================================
log "Ejecutando antiamnesia..."
$BASE/02-SISTEMA/ANTIAMNESIA/snx_antiamnesia_soberano_v3.sh >> "$LOGFILE" 2>&1
log "Antiamnesia ejecutado correctamente"

# ============================================================
# 8. GENERAR INFORME FINAL
# ============================================================
{
  echo "# INFORME DE CERTIFICACIÓN DEL SISTEMA"
  echo "Fecha: $(date)"
  echo
  echo "## Estados ministeriales"
  ls -1 "$MEM"/estado_*.json
  echo
  echo "## Engranajes"
  ls -1 "$MEM"/engranaje_*.json
  echo
  echo "## Sync"
  ls -1 "$MEM"/sync_*.json
  echo
  echo "## Hashes"
  ls -1 "$MEM"/HASHES/*.sha
  echo
  echo "## Logs generados"
  ls -1 "$LOG"
} > "$REPORTE"

log "VALIDACION CERTIFICADA COMPLETADA"
log "Informe generado: $REPORTE"

