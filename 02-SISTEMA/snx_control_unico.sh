#!/data/data/com.termux/files/usr/bin/bash
# SODA-NEXUS — CONTROLADOR ÚNICO DEL SISTEMA
# Versión: 1.0 - Unifica wake-lock, backend y watchdog mínimo

LOG_DIR="$HOME/soda/04-REGISTROS/SYSTEM"
mkdir -p "$LOG_DIR"
LOG="$LOG_DIR/control_unico_$(date +%Y%m%d).log"

echo "[$(date)] INICIANDO CONTROLADOR ÚNICO" | tee -a "$LOG"

# Activar wake-lock
termux-wake-lock
echo "[$(date)] Wake-lock activado" >> "$LOG"

# Verificar si el backend ya está corriendo
if pgrep -f "snx_monitor_backend.py" > /dev/null; then
    echo "[$(date)] Backend ya está corriendo" >> "$LOG"
else
    cd ~/soda/02-SISTEMA/BACKEND/
    nohup python3 snx_monitor_backend.py > ~/soda/backend.log 2>&1 &
    echo "[$(date)] Backend iniciado (puerto 5000)" >> "$LOG"
fi

# Verificación cada 5 minutos (loop ligero)
while true; do
    sleep 300
    if ! pgrep -f "snx_monitor_backend.py" > /dev/null; then
        echo "[$(date)] Backend caído. Reiniciando..." >> "$LOG"
        cd ~/soda/02-SISTEMA/BACKEND/
        nohup python3 snx_monitor_backend.py > ~/soda/backend.log 2>&1 &
    fi
done
