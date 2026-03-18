from flask import Flask, request, jsonify
import requests, os

app = Flask(__name__)

ORQ = "http://127.0.0.1:5051"
MON = "http://127.0.0.1:5052"

def safe_get(url):
    try:
        r = requests.get(url, timeout=3)
        return r.json()
    except:
        return {"status": "error", "detail": f"no responde: {url}"}

@app.route("/monitor_estado")
def monitor_estado():
    return jsonify({
        "orquestador": safe_get(f"{ORQ}/health"),
        "monitor": safe_get(f"{MON}/estado")
    })

@app.route("/estado")
def estado():
    return jsonify(safe_get(f"{MON}/estado"))

@app.route("/carpetas")
def carpetas():
    path = request.args.get("path", "")
    return jsonify(safe_get(f"{MON}/carpetas?path={path}"))

@app.route("/archivo")
def archivo():
    path = request.args.get("path", "")
    return jsonify(safe_get(f"{MON}/archivo?path={path}"))

@app.route("/ia_contexto")
def ia_contexto():
    return jsonify(safe_get(f"{ORQ}/health"))

@app.route("/motores")
def motores():
    return jsonify(safe_get(f"{ORQ}/health"))

@app.route("/proposito")
def proposito():
    return {"proposito": "SODA-NEXUS en operación"}

@app.route("/ruta")
def ruta():
    return {"ruta": "Operación soberana activa"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5053)
