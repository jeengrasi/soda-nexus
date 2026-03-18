#!/data/data/com.termux/files/usr/bin/bash
set -e

BACKEND="$HOME/soda/02-SISTEMA/BACKEND/snx_monitor_unificado.py"
MONITOR_DIR="$HOME/soda/06-MONITOR"

echo "[INFO] === PARCHE FINAL: SERVIR MONITOR DESDE 5050 ==="

# Backup
cp "$BACKEND" "$BACKEND.backup.$(date +%Y%m%d_%H%M%S)"
echo "[INFO] Backup creado."

# Asegurar import
if ! grep -q "send_from_directory" "$BACKEND"; then
    sed -i '1i from flask import send_from_directory' "$BACKEND"
fi

# Insertar ruta si no existe
if ! grep -q "serve_monitor" "$BACKEND"; then
    sed -i "/socketio = SocketIO/a \
@app.route('/')\n\
@app.route('/<path:path>')\n\
def serve_monitor(path='index.html'):\n\
    return send_from_directory('$MONITOR_DIR', path)\n" "$BACKEND"
fi

echo "[INFO] Ruta para servir monitor añadida."

# Reiniciar servicio
echo "[INFO] Reiniciando servicio snx-monitor..."
pkill -f snx_monitor_unificado.py || true
sleep 2
sv restart snx-monitor || sv up snx-monitor

echo "[INFO] Verificando..."
sleep 3
curl -s http://127.0.0.1:5050/ | head

echo "[INFO] PARCHE COMPLETADO."
