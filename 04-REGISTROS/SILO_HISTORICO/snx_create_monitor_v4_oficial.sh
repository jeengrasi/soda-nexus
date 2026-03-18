#!/data/data/com.termux/files/usr/bin/bash
set -e

MONITOR_SRC="$HOME/soda/03-OPERACIONES/WEB/monitor"
MONITOR_DST="$HOME/soda/06-MONITOR/V4-OFICIAL"

echo "[INFO] Creando monitor oficial V4..."

mkdir -p "$MONITOR_DST"

# Copiar monitor actual sin modificarlo
cp -r "$MONITOR_SRC"/* "$MONITOR_DST/"

echo "[INFO] Monitor V4-OFICIAL creado en:"
echo "       $MONITOR_DST"

# Parchear backend unificado para servir este monitor
BACKEND="$HOME/soda/02-SISTEMA/BACKEND/snx_monitor_unificado.py"

# Backup
cp "$BACKEND" "$BACKEND.backup.$(date +%Y%m%d_%H%M%S)"

# Asegurar import
if ! grep -q "send_from_directory" "$BACKEND"; then
    sed -i '1i from flask import send_from_directory' "$BACKEND"
fi

# Insertar ruta correcta
sed -i "/socketio = SocketIO/a \
MONITOR_DIR = '$MONITOR_DST'\n\
@app.route('/')\n\
@app.route('/<path:path>')\n\
def serve_monitor(path='index.html'):\n\
    return send_from_directory(MONITOR_DIR, path)\n" "$BACKEND"

echo "[INFO] Reiniciando servicio snx-monitor..."
pkill -f snx_monitor_unificado.py || true
sleep 2
sv restart snx-monitor || sv up snx-monitor

echo "[INFO] Verificando..."
sleep 3
curl -s http://127.0.0.1:5050/ | head

echo "[INFO] Monitor V4-OFICIAL activado."
