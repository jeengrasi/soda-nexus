from flask import Flask, send_from_directory, jsonify
import os, json

app = Flask(__name__, static_folder="/data/data/com.termux/files/home/soda/06-MONITOR/V4-OFICIAL", static_url_path="")

CONTEXT_FILE = "/data/data/com.termux/files/home/soda/00-GOBIERNO/ESTADO/snx_contexto_soberano.json"

@app.route("/")
def index():
    return send_from_directory(app.static_folder, "index.html")

@app.route("/<path:path>")
def static_proxy(path):
    full_path = os.path.join(app.static_folder, path)
    if os.path.isfile(full_path):
        return send_from_directory(app.static_folder, path)
    return ("Not Found", 404)

@app.route("/antiamnesia_estado", methods=["GET"])
def antiamnesia_estado():
    if os.path.exists(CONTEXT_FILE):
        with open(CONTEXT_FILE, "r") as f:
            data = json.load(f)
        return jsonify(data)
    else:
        return jsonify({"error": "contexto soberano no encontrado"}), 404

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050)
