#!/data/data/com.termux/files/usr/bin/bash

CONTEXT_FILE="$HOME/soda/00-GOBIERNO/ESTADO/snx_contexto_soberano.json"
LOG_FILE="$HOME/soda/05-REGISTROS/ANTIAMNESIA/snx_antiamnesia.log"

mkdir -p "$(dirname $LOG_FILE)"

timestamp=$(date +"%Y-%m-%d %H:%M:%S")

backend_status="desconocido"
monitor_status="desconocido"
ia_status="desconocido"
tunnel_status="desconocido"

# Verificar backend
if curl -s http://127.0.0.1:5050/estado >/dev/null; then
    backend_status="ok"
else
    backend_status="caido"
fi

# Verificar IA
if curl -s http://127.0.0.1:5050/ia_contexto >/dev/null; then
    ia_status="ok"
else
    ia_status="desconectada"
fi

# Verificar monitor oficial
if curl -s http://127.0.0.1:5050/index.html | grep -q "<html"; then
    monitor_status="ok"
else
    monitor_status="desviado"
fi

# Verificar túnel
if ip route | grep -q "tun"; then
    tunnel_status="activo"
else
    tunnel_status="inactivo"
fi

# Actualizar archivo soberano
cat > "$CONTEXT_FILE" <<EOF2
{
  "monitor_oficial": "/soda/06-MONITOR/V4-OFICIAL",
  "backend_oficial": "http://127.0.0.1:5050",
  "estado_backend": "$backend_status",
  "estado_monitor": "$monitor_status",
  "estado_ia": "$ia_status",
  "estado_tunel": "$tunnel_status",
  "ultima_verificacion": "$timestamp"
}
EOF2

# Registrar log
echo "[$timestamp] backend=$backend_status monitor=$monitor_status ia=$ia_status tunel=$tunnel_status" >> "$LOG_FILE"
