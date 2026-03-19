#!/data/data/com.termux/files/usr/bin/bash
# SNX — WATCHDOG SOBERANO V6  # [OBS] Encabezado institucional: Protege el mando único.

# [OBS] Nueva ruta de logs en el Ministerio 04 (Registro Soberano).
LOG="$HOME/soda/04-REGISTROS/SYSTEM/daemon_monitor_watchdog_v6.log"

while true; do
  # [OBS] Ahora vigila el Orquestador Maestro en lugar del servidor 8080.
  if ! pgrep -f "ORQUESTADOR_MAESTRO.py" > /dev/null; then
    echo "[$(date)] [WATCHDOG] Orquestador V6 caído — Reiniciando mando..." >> "$LOG"
    # [OBS] Reinicia el mando oficial desde su ubicación certificada.
    nohup python3 ~/soda/02-SISTEMA/ORQUESTADOR_MAESTRO.py >> ~/soda/04-REGISTROS/SYSTEM/api_runtime.log 2>&1 &
  fi
  sleep 60 # [OBS] Ciclo de vigilancia de 1 minuto.
done

# --------------------------------------------------------------
# SNX — PIE DE PÁGINA INSTITUCIONAL (VERSIÓN V6 2026)
# Este script evoluciona la lógica de persistencia del monitor original.
# --------------------------------------------------------------
