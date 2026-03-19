#!/data/data/com.termux/files/usr/bin/bash
# SNX — AUDITOR & CONTROLADOR V6.2 # [OBS] Letra auditada: Blindaje de Prioridad CPU.

LOG_REPORTE="$HOME/soda/04-REGISTROS/SYSTEM/reporte_controlador_v6.log"
MINISTERIO_API="$HOME/soda/02-SISTEMA/API"

ejecutar_limpieza_y_prioridad() {
    # [OBS] Limpieza de desviaciones V2/V3 (Evitar Signal 9 por saturación).
    ZOMBIES=$(pgrep -f "snx_monitor_unificado_v2|http.server 8080")
    [ ! -z "$ZOMBIES" ] && kill -9 $ZOMBIES 2>/dev/null

    # [OBS] Gestión de Prioridad (Garantizar potencia y ligereza).
    # Elevamos a todos los procesos críticos a -20 inmediatamente.
    pgrep -f "ORQUESTADOR_V6.py|sshd" | xargs renice -n -20 2>/dev/null

    # [OBS] Rescate del Mando.
    if ! pgrep -f "ORQUESTADOR_V6.py" > /dev/null; then
        echo "[$(date)] [RESCATE] Orquestador V6 offline. Reiniciando con prioridad máxima." >> "$LOG_REPORTE"
        nohup python3 $MINISTERIO_API/ORQUESTADOR_V6.py >> $HOME/soda/04-REGISTROS/SYSTEM/api_runtime.log 2>&1 &
    fi
}

while true; do
    ejecutar_limpieza_y_prioridad
    sleep 300
done
