from flask import Flask, send_from_directory, jsonify
import os, json

# Ruta del monitor que ya estás usando
STATIC_ROOT = "/data/data/com.termux/files/home/soda/06-MONITOR/V3"
CONTEXT_FILE = "/data/data/com.termux/files/home/soda/00-GOBIERNO/ESTADO/snx_contexto_soberano.json"

app = Flask(__name__, static_folder=STATIC_ROOT, static_url_path="")

@app.route("/")
def index():
    # Servir el mismo HTML que ya ves en 8080
    return send_from_directory(STATIC_ROOT, "monitor_soberano_v2.html")

@app.route("/<path:path>")
def static_proxy(path):
    full_path = os.path.join(STATIC_ROOT, path)
    if os.path.isfile(full_path):
        return send_from_directory(STATIC_ROOT, path)
    return ("Not Found", 404)

@app.route("/monitor_estado")
def monitor_estado():
    # Estado mínimo para que el monitor deje de mostrar "Cargando..."
    return jsonify({
        "estado": "ok",
        "mensaje": "Monitor operativo",
        "centro": "Termux",
        "ia": "DeepSeek (dedicada)",
        "motores": [],
        "desviaciones": [],
        "ultima_actualizacion": "desde backend Flask"
    })

@app.route("/ia_contexto")
def ia_contexto():
    # Contexto mínimo para la pestaña IA Dedicada
    return jsonify({
        "estado": "ok",
        "contexto": "IA conectada al backend unificado",
        "detalle": "Contexto básico operativo"
    })

@app.route("/antiamnesia_estado")
def antiamnesia_estado():
    # Integración con el sistema antiamnesia que ya creaste
    if os.path.exists(CONTEXT_FILE):
        with open(CONTEXT_FILE, "r") as f:
            data = json.load(f)
        return jsonify(data)
    return jsonify({"error": "contexto soberano no encontrado"}), 404

if __name__ == "__main__":
    # Escuchar en el mismo puerto que ya usas en el iPad
    app.run(host="0.0.0.0", port=8080)
