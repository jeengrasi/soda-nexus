#!/data/data/com.termux/files/usr/bin/bash
set -e

BASE="$HOME/soda"
REG_SYS="$BASE/04-REGISTROS/SYSTEM"
mkdir -p "$REG_SYS"

TS="$(date +%Y%m%d_%H%M%S)"
LOG_AUD="$REG_SYS/auditoria_total_$TS.log"

echo "==========================================" | tee -a "$LOG_AUD"
echo "[AUDITORIA TOTAL] SODA-NEXUS $TS" | tee -a "$LOG_AUD"
echo "BASE: $BASE" | tee -a "$LOG_AUD"
echo "==========================================" | tee -a "$LOG_AUD"

echo "[1] Snapshot tree ~/soda" | tee -a "$LOG_AUD"
tree -a "$BASE" > "$REG_SYS/tree_$TS.log" 2>>"$LOG_AUD" || echo "tree fallo (ok)" | tee -a "$LOG_AUD"

echo "[2] Snapshot ls -lR ~/soda" | tee -a "$LOG_AUD"
ls -lR "$BASE" > "$REG_SYS/ls_lR_$TS.log" 2>>"$LOG_AUD" || echo "ls -lR fallo (ok)" | tee -a "$LOG_AUD"

echo "[3] Verificación de piezas críticas" | tee -a "$LOG_AUD"

check_file() {
  local path="$1"
  if [ -f "$path" ]; then
    echo "[OK] FILE: $path" | tee -a "$LOG_AUD"
  else
    echo "[FALTA] FILE: $path" | tee -a "$LOG_AUD"
  fi
}

check_dir() {
  local path="$1"
  if [ -d "$path" ]; then
    echo "[OK] DIR: $path" | tee -a "$LOG_AUD"
  else
    echo "[FALTA] DIR: $path" | tee -a "$LOG_AUD"
  fi
}

# Directorios base
check_dir "$BASE/00-GOBIERNO"
check_dir "$BASE/01-MEMORIA"
check_dir "$BASE/02-SISTEMA"
check_dir "$BASE/03-OPERACIONES"
check_dir "$BASE/04-REGISTROS"
check_dir "$BASE/05-DOCUMENTACION"
check_dir "$BASE/06-MONITOR"

# Backend / API
check_file "$BASE/02-SISTEMA/API/api_v4.py"
check_file "$BASE/02-SISTEMA/API/api_v3.py"
check_file "$BASE/02-SISTEMA/API/api.py"
check_file "$BASE/02-SISTEMA/API/iniciar_orquestador_v4.sh"

# Monitor backend
check_dir  "$BASE/02-SISTEMA/BACKEND/MONITOR"
check_file "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend.py"
check_file "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend_run.sh"
check_file "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_endpoint_data_v1.py"
check_file "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_publish_v1.sh"

# Monitor frontend / JS
check_file "$BASE/03-OPERACIONES/monitor.js"
check_file "$BASE/02-SISTEMA/BACKEND/monitor_soberano.py"
check_file "$HOME/soda/monitor_estado"

# VAULT / IA
check_dir  "$BASE/02-SISTEMA/VAULT"
check_file "$BASE/02-SISTEMA/VAULT/LOCAL_IA_MODEL"
check_file "$BASE/02-SISTEMA/VAULT/REMOTE_IA_URL"
check_file "$BASE/02-SISTEMA/VAULT/REMOTE_IA_MODEL"
check_file "$BASE/02-SISTEMA/VAULT/REMOTE_IA_KEY"
check_file "$BASE/02-SISTEMA/VAULT/CURRENT_MOTOR.json"

# Protocolo herramientas
check_file "$BASE/04-DOCS/PROTOCOLO_HERRAMIENTAS.md"

echo "[4] Permisos de ejecución en BACKEND/MONITOR" | tee -a "$LOG_AUD"

mark_exec() {
  local path="$1"
  if [ -f "$path" ]; then
    if [ ! -x "$path" ]; then
      chmod +x "$path"
      echo "[FIX] chmod +x $path" | tee -a "$LOG_AUD"
    else
      echo "[OK] ejecutable: $path" | tee -a "$LOG_AUD"
    fi
  else
    echo "[SKIP] no existe: $path" | tee -a "$LOG_AUD"
  fi
}

mark_exec "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend.py"
mark_exec "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend_run.sh"
mark_exec "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_endpoint_data_v1.py"
mark_exec "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_publish_v1.sh"
mark_exec "$BASE/02-SISTEMA/API/iniciar_orquestador_v4.sh"
mark_exec "$BASE/02-SISTEMA/BACKEND/run_monitor.sh"
mark_exec "$BASE/02-SISTEMA/BACKEND/snx_backend.sh"
mark_exec "$BASE/02-SISTEMA/DAEMON/snx_daemon.sh"

echo "[5] Estado del puerto 5051 (backend central)" | tee -a "$LOG_AUD"
ss -tulpn 2>/dev/null | grep 5051 || echo "No se ve nada escuchando en 5051 (puede ser normal si está apagado)" | tee -a "$LOG_AUD"

echo "[6] Ping a /ping_v4 si está arriba" | tee -a "$LOG_AUD"
if curl -s http://127.0.0.1:5051/ping_v4 >/dev/null 2>&1; then
  echo "[OK] /ping_v4 responde" | tee -a "$LOG_AUD"
else
  echo "[WARN] /ping_v4 no responde" | tee -a "$LOG_AUD"
fi

echo "==========================================" | tee -a "$LOG_AUD"
echo "[AUDITORIA TOTAL COMPLETADA] Log: $LOG_AUD" | tee -a "$LOG_AUD"
echo "==========================================" | tee -a "$LOG_AUD"
