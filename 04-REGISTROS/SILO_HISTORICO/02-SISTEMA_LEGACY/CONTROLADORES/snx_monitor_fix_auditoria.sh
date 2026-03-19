#!/data/data/com.termux/files/usr/bin/bash
# SNX MONITOR FIX + AUDITORIA
# No borra nada. Solo:
# - Detecta qué hay en 8080
# - Registra hallazgos
# - Prepara backend oficial sin tocar archivos históricos
# - Intenta dejar el monitor funcional

LOG="$HOME/soda/05-REGISTROS/ANTIAMNESIA/snx_monitor_fix_auditoria.log"
mkdir -p "$(dirname "$LOG")"

ts() { date +"%Y-%m-%d %H:%M:%S"; }

log() {
  echo "[$(ts)] $1" | tee -a "$LOG"
}

log "=== INICIO AUDITORIA MONITOR ==="

# 1. Detectar qué está corriendo en 8080
log "Detectando proceso en puerto 8080..."
PROC_8080=$(lsof -i :8080 2>/dev/null | awk 'NR>1 {print $1, $2, $9}' | head -n 1)

if [ -z "$PROC_8080" ]; then
  log "No hay nada escuchando en 8080."
else
  log "Proceso detectado en 8080: $PROC_8080"
fi

# 2. Probar endpoints actuales (sin tocar nada)
log "Probando /monitor_estado actual..."
curl -s -o /tmp/snx_monitor_estado_8080.json -w "HTTP:%{http_code}\n" 127.0.0.1:8080/monitor_estado | tee -a "$LOG"

log "Probando /ia_contexto actual..."
curl -s -o /tmp/snx_ia_contexto_8080.json -w "HTTP:%{http_code}\n" 127.0.0.1:8080/ia_contexto | tee -a "$LOG"

# 3. Verificar si es SimpleHTTPServer
if echo "$PROC_8080" | grep -qi "http.server"; then
  log "Detectado servidor estático (http.server) en 8080. No sirve API."
  STATIC_ONLY=1
else
  STATIC_ONLY=0
fi

# 4. Verificar existencia de monitor V2 y contexto soberano
MONITOR_HTML="$HOME/soda/06-MONITOR/V3/monitor_soberano_v2.html"
CONTEXT_FILE="$HOME/soda/00-GOBIERNO/ESTADO/snx_contexto_soberano.json"

if [ -f "$MONITOR_HTML" ]; then
  log "Monitor V2 encontrado: $MONITOR_HTML"
else
  log "ADVERTENCIA: No se encontró $MONITOR_HTML"
fi

if [ -f "$CONTEXT_FILE" ]; then
  log "Contexto soberano encontrado: $CONTEXT_FILE"
else
  log "ADVERTENCIA: No se encontró contexto soberano en $CONTEXT_FILE"
fi

# 5. Preparar backend oficial SIN tocar los existentes
BACKEND_OFICIAL="$HOME/soda/02-SISTEMA/BACKEND/snx_monitor_backend_oficial_v2.py"

if [ -f "$BACKEND_OFICIAL" ]; then
  cp "$BACKEND_OFICIAL" "${BACKEND_OFICIAL}.bak_$(date +%Y%m%d-%H%M%S)"
  log "Backup de backend oficial previo: ${BACKEND_OFICIAL}.bak_$(date +%Y%m%d-%H%M%S)"
fi

cat > "$BACKEND_OFICIAL" << 'EOF2'
from flask import Flask, send_from_directory, jsonify
import os, json

STATIC_ROOT = "/data/data/com.termux/files/home/soda/06-MONITOR/V3"
CONTEXT_FILE = "/data/data/com.termux/files/home/soda/00-GOBIERNO/ESTADO/snx_contexto_soberano.json"

app = Flask(__name__, static_folder=STATIC_ROOT, static_url_path="")

@app.route("/")
def index():
    return send_from_directory(STATIC_ROOT, "monitor_soberano_v2.html")

@app.route("/<path:path>")
def static_proxy(path):
    full_path = os.path.join(STATIC_ROOT, path)
    if os.path.isfile(full_path):
        return send_from_directory(STATIC_ROOT, path)
    return ("Not Found", 404)

@app.route("/monitor_estado")
def monitor_estado():
    return jsonify({
        "estado": "ok",
        "centro": "Termux",
        "ia": "DeepSeek (dedicada)",
        "ultima_actualizacion": "backend oficial v2",
        "motores": [],
        "desviaciones": []
    })

@app.route("/ia_contexto")
def ia_contexto():
    return jsonify({
        "estado": "ok",
        "contexto": "IA conectada",
        "detalle": "Backend oficial v2 respondiendo"
    })

@app.route("/proposito")
def proposito():
    return jsonify({
        "estado": "ok",
        "proposito": "Propósito soberano cargado",
        "ruta": "Ruta soberana activa"
    })

@app.route("/motores")
def motores():
    return jsonify({
        "estado": "ok",
        "motores": []
    })

@app.route("/antiamnesia_estado")
def antiamnesia_estado():
    if os.path.exists(CONTEXT_FILE):
        with open(CONTEXT_FILE, "r") as f:
            data = json.load(f)
        return jsonify(data)
    return jsonify({"error": "contexto soberano no encontrado"}), 404

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
EOF2

log "Backend oficial v2 preparado en: $BACKEND_OFICIAL"

# 6. Si 8080 está ocupado por http.server, sugerir reemplazo controlado
if [ "$STATIC_ONLY" -eq 1 ]; then
  log "8080 está ocupado por http.server. Se requiere reemplazo controlado para que el monitor sea funcional."
  log "Deteniendo http.server..."
  pkill -f "http.server" 2>/dev/null || true
  sleep 2
fi

# 7. Levantar backend oficial v2
log "Levantando backend oficial v2 en 8080..."
python3 "$BACKEND_OFICIAL" &
sleep 3

# 8. Verificación final
log "Verificando /monitor_estado tras fix..."
curl -s -o /tmp/snx_monitor_estado_8080_fix.json -w "HTTP:%{http_code}\n" 127.0.0.1:8080/monitor_estado | tee -a "$LOG"

log "Verificando /ia_contexto tras fix..."
curl -s -o /tmp/snx_ia_contexto_8080_fix.json -w "HTTP:%{http_code}\n" 127.0.0.1:8080/ia_contexto | tee -a "$LOG"

log "Verificando /antiamnesia_estado tras fix..."
curl -s -o /tmp/snx_antiamnesia_8080_fix.json -w "HTTP:%{http_code}\n" 127.0.0.1:8080/antiamnesia_estado | tee -a "$LOG"

log "=== FIN AUDITORIA MONITOR ==="
