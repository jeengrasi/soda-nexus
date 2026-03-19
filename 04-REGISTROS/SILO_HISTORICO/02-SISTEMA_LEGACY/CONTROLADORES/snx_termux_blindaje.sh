#!/data/data/com.termux/files/usr/bin/bash
# SNX-TERMUX-BLINDAJE-V6 — SODA-NEXUS # [OBS] Propósito: Persistencia y prevención de Signal 9.

SODA="$HOME/soda"
# [OBS] Nueva ruta lógica centralizada para logs de sistema.
REGISTROS="$SODA/04-REGISTROS/SYSTEM"
mkdir -p "$REGISTROS"

registrar() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> "$REGISTROS/blindaje_v6.log"
}

# [OBS] Activación de Wake-lock (Soberanía de Hardware).
termux-wake-lock && registrar "Wake-lock activo."

registrar "Iniciando limpieza preventiva de procesos zombies..."
# [OBS] Mata procesos python que NO sean el Orquestador V6 para liberar RAM.
pgrep -f "python" | grep -v $(pgrep -f "ORQUESTADOR_V6.py") | xargs kill -9 2>/dev/null

while true; do
    # [OBS] Vigilancia activa: Si no hay Orquestador V6, lo levanta.
    if ! pgrep -f "ORQUESTADOR_V6.py" > /dev/null; then
        registrar "ALERTA: Orquestador V6 no detectado. Reiniciando..."
        nohup python3 $SODA/02-SISTEMA/API/ORQUESTADOR_V6.py >> $REGISTROS/api_runtime.log 2>&1 &
    fi
    sleep 300
    registrar "Latido V6: Sistema estable."
done

# ----------------------------------------------------------------------------
# PIE DE PÁGINA: Este script centraliza la vida del sistema. 
# Reemplaza a todos los daemons de persistencia antiguos.
# ----------------------------------------------------------------------------
