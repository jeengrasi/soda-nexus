#!/data/data/com.termux/files/usr/bin/bash
set -e

BASE="$HOME/soda"
REG_SYS="$BASE/04-REGISTROS/SYSTEM"
mkdir -p "$REG_SYS"

TS="$(date +%Y%m%d_%H%M%S)"
LOG="$REG_SYS/auditoria_stack_monitor_$TS.log"

log() {
  echo "$@" | tee -a "$LOG"
}

log "=========================================="
log "[AUDITORIA STACK MONITOR] $TS"
log "BASE: $BASE"
log "=========================================="

# 1) Verificación de archivos críticos
check_file() {
  local path="$1"
  if [ -f "$path" ]; then
    log "[OK] FILE: $path"
  else
    log "[FALTA] FILE: $path"
  fi
}

check_file "$BASE/02-SISTEMA/API/api_v4.py"
check_file "$BASE/02-SISTEMA/API/iniciar_orquestador_v4.sh"
check_file "$BASE/02-SISTEMA/BACKEND/monitor_soberano.py"
check_file "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend.py"
check_file "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend_run.sh"
check_file "$BASE/02-SISTEMA/BACKEND/monitor_bridge_v1.py"
check_file "$BASE/02-SISTEMA/BACKEND/monitor_bridge_run.sh"
check_file "$BASE/monitor_estado"

# 2) Permisos de ejecución
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
    log "[SKIP] no existe: $path"
  fi
}

log "[PERMISOS]"
mark_exec "$BASE/02-SISTEMA/API/iniciar_orquestador_v4.sh"
mark_exec "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend_run.sh"
mark_exec "$BASE/02-SISTEMA/BACKEND/monitor_bridge_run.sh"

# 3) Estado de puertos y endpoints
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

log "[ENDPOINTS]"
test_curl "ORQ_V4 /ping_v4" "http://127.0.0.1:5051/ping_v4"
test_curl "ORQ_V4 /health"  "http://127.0.0.1:5051/health"
test_curl "MONITOR /estado" "http://127.0.0.1:5052/estado"
test_curl "BRIDGE /monitor_estado" "http://127.0.0.1:5053/monitor_estado"
test_curl "BRIDGE /estado" "http://127.0.0.1:5053/estado"
test_curl "BRIDGE /ia_contexto" "http://127.0.0.1:5053/ia_contexto"

log "=========================================="
log "[AUDITORIA STACK MONITOR COMPLETADA] Log: $LOG"
log "=========================================="
