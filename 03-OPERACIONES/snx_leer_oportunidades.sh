#!/data/data/com.termux/files/usr/bin/bash
LOG_FILE="/data/data/com.termux/files/home/soda/04-REGISTROS/motor_ingresos_v1.log"
if [ -f "$LOG_FILE" ]; then
    tail -n 10 "$LOG_FILE"
else
    echo "Esperando primera ejecución del Motor..."
fi
