#!/data/data/com.termux/files/usr/bin/bash
set -e

BASE="$HOME/soda"
REG_SYS="$BASE/04-REGISTROS/SYSTEM"
mkdir -p "$REG_SYS"

TS="$(date +%Y%m%d_%H%M%S)"
LOG="$REG_SYS/correcion_total_$TS.log"

echo "==========================================" | tee -a "$LOG"
echo "[CORRECCION TOTAL] SODA-NEXUS $TS" | tee -a "$LOG"
echo "==========================================" | tee -a "$LOG"

# ---------------------------------------------------------
# 1. REPARAR PERMISOS DE BACKEND MONITOR
# ---------------------------------------------------------
fix_exec() {
  if [ -f "$1" ]; then
    chmod +x "$1"
    echo "[OK] ejecutable: $1" | tee -a "$LOG"
  else
    echo "[FALTA] $1" | tee -a "$LOG"
  fi
}

fix_exec "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend.py"
fix_exec "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend_run.sh"
fix_exec "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_endpoint_data_v1.py"
fix_exec "$BASE/02-SISTEMA/BACKEND/MONITOR/snx_monitor_publish_v1.sh"
fix_exec "$BASE/02-SISTEMA/API/iniciar_orquestador_v4.sh"

# ---------------------------------------------------------
# 2. CREAR monitor_estado (el monitor lo exige)
# ---------------------------------------------------------
MON="$BASE/monitor_estado"
echo "[INFO] Creando monitor_estado" | tee -a "$LOG"

cat > "$MON" << EOF2
{
  "backend": "http://127.0.0.1:5051",
  "version": "v4",
  "updated": "$(date -Iseconds)"
}
EOF2

echo "[OK] monitor_estado creado" | tee -a "$LOG"

# ---------------------------------------------------------
# 3. PARCHEAR monitor.js (contrato viejo → contrato V4)
# ---------------------------------------------------------
MON_JS="$BASE/03-OPERACIONES/monitor.js"

if [ -f "$MON_JS" ]; then
  cp "$MON_JS" "$MON_JS.bak_$TS"
  sed -i 's/\/estado/\/health/g' "$MON_JS"
  sed -i 's/\/carpetas/\/carpeta/g' "$MON_JS"
  echo "[OK] monitor.js alineado a V4" | tee -a "$LOG"
else
  echo "[FALTA] monitor.js" | tee -a "$LOG"
fi

# ---------------------------------------------------------
# 4. LEVANTAR ORQUESTADOR V4
# ---------------------------------------------------------
echo "[RUN] Iniciando Orquestador V4" | tee -a "$LOG"
pkill -f api_v4.py 2>/dev/null || true
nohup bash "$BASE/02-SISTEMA/API/iniciar_orquestador_v4.sh" >> "$REG_SYS/orq_v4_$TS.out" 2>&1 &

sleep 3

if curl -s http://127.0.0.1:5051/ping_v4 >/dev/null 2>&1; then
  echo "[OK] /ping_v4 responde" | tee -a "$LOG"
else
  echo "[ERROR] /ping_v4 NO responde" | tee -a "$LOG"
fi

echo "==========================================" | tee -a "$LOG"
echo "[CORRECCION TOTAL COMPLETADA]" | tee -a "$LOG"
echo "==========================================" | tee -a "$LOG"
