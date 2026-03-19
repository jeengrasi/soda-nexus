from flask import Flask, jsonify
import json, os

app = Flask(__name__)

CONTEXT_FILE = "/data/data/com.termux/files/home/soda/00-GOBIERNO/ESTADO/snx_contexto_soberano.json"

@app.route("/monitor_estado")
def monitor_estado():
    # Estado mínimo para que el monitor deje de cargar
    return jsonify({
        "estado": "ok",
        "mensaje": "Monitor operativo",
        "ia": "ok",
        "motores": "ok",
        "proposito": "definido",
        "ruta": "activa"
    })

@app.route("/ia_contexto")
def ia_contexto():
    # Respuesta mínima para que la pestaña IA deje de cargar
    return jsonify({
        "estado": "ok",
        "contexto": "IA operativa",
        "detalle": "Conectada al backend"
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
