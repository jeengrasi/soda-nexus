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
