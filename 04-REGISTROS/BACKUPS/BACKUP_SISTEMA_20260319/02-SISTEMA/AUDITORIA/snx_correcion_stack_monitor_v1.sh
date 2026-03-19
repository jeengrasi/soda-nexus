#!/data/data/com.termux/files/usr/bin/bash
set -e

BASE="$HOME/soda"
REG_SYS="$BASE/04-REGISTROS/SYSTEM"
mkdir -p "$REG_SYS"

TS="$(date +%Y%m%d_%H%M%S)"
LOG="$REG_SYS/correcion_stack_monitor_$TS.log"

log() {
  echo "$@" | tee -a "$LOG"
}

log "=========================================="
log "[CORRECCION STACK MONITOR] $TS"
log "BASE: $BASE"
log "=========================================="

# 1) Asegurar permisos
mark_exec() {
  local path="$1"
  if [ -f "$path" ]; then
    if [ ! -x "$path" ]; then
      chmod +x "$path"
      log "[FIX] chmod +x $path"
    else
      log "[OK] ejecutable: $path"
    fi
  else
    log "[WARN] no existe: $path"
  fi
}

mark_exec "$BASE/02-SISTEMA/API/iniciar_orquestador_v4.sh"
mark_exec "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend_run.sh"
mark_exec "$BASE/02-SISTEMA/BACKEND/monitor_bridge_run.sh"

# 2) Limpiar procesos previos
log "[KILL] api_v4 / monitor_backend / bridge"
pkill -f api_v4.py 2>/dev/null || true
pkill -f snx_monitor_backend.py 2>/dev/null || true
pkill -f monitor_bridge_v1.py 2>/dev/null || true

sleep 2

# 3) Arrancar Orquestador V4 (5051)
log "[RUN] Orquestador V4"
nohup bash "$BASE/02-SISTEMA/API/iniciar_orquestador_v4.sh" \
  >> "$REG_SYS/orq_v4_$TS.out" 2>&1 &

sleep 4

# 4) Arrancar Backend Monitor (5052)
log "[RUN] Backend Monitor (snx_monitor_backend_run.sh)"
nohup bash "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend_run.sh" \
  >> "$REG_SYS/monitor_backend_$TS.out" 2>&1 &

sleep 4

# 5) Arrancar Bridge (5053)
log "[RUN] Bridge Monitor (monitor_bridge_run.sh)"
nohup bash "$BASE/02-SISTEMA/BACKEND/monitor_bridge_run.sh" \
  >> "$REG_SYS/monitor_bridge_$TS.out" 2>&1 &

sleep 4

# 6) Verificación final con curl
test_curl() {
  local label="$1"
  local url="$2"
  if curl -s "$url" >/dev/null 2>&1; then
    local out
    out="$(curl -s "$url")"
    log "[OK] $label -> $url"
    log "     RESP: $out"
  else
    log "[FAIL] $label -> $url (no responde)"
  fi
}

log "[CHECK] ENDPOINTS FINALES"
test_curl "ORQ_V4 /ping_v4" "http://127.0.0.1:5051/ping_v4"
test_curl "ORQ_V4 /health"  "http://127.0.0.1:5051/health"
test_curl "MONITOR /estado" "http://127.0.0.1:5052/estado"
test_curl "BRIDGE /monitor_estado" "http://127.0.0.1:5053/monitor_estado"
test_curl "BRIDGE /estado" "http://127.0.0.1:5053/estado"
test_curl "BRIDGE /ia_contexto" "http://127.0.0.1:5053/ia_contexto"

log "=========================================="
log "[CORRECCION STACK MONITOR COMPLETADA] Log: $LOG"
log "=========================================="
