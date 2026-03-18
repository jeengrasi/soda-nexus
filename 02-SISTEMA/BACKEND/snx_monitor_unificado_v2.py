#!/data/data/com.termux/files/usr/bin/python3
import os, json, requests
from flask import Flask, send_from_directory, jsonify, request
from flask_socketio import SocketIO, emit
from datetime import datetime

# === CONFIGURACIÓN OFICIAL ===
MONITOR_DIR = "/data/data/com.termux/files/home/soda/06-MONITOR/V4-OFICIAL"

app = Flask(__name__, static_folder=MONITOR_DIR)
socketio = SocketIO(app, cors_allowed_origins="*")

# === SERVIR MONITOR OFICIAL ===
@app.route('/')
@app.route('/<path:path>')
def serve_monitor(path='index.html'):
    return send_from_directory(MONITOR_DIR, path)

# === ENDPOINTS API ===
@app.route('/monitor_estado')
def monitor_estado():
    try:
        orq = requests.get("http://127.0.0.1:5051/health", timeout=2).json()
    except:
        orq = {"status": "offline"}

    try:
        mon = requests.get("http://127.0.0.1:5052/estado", timeout=2).json()
    except:
        mon = {"status": "offline"}

    return jsonify({
        "monitor": mon,
        "orquestador": orq,
        "timestamp": datetime.now().isoformat()
    })

@app.route('/estado')
def estado():
    return jsonify({
        "status": "online",
        "sistema": "SODA-NEXUS",
        "version": "V4-OFICIAL",
        "timestamp": datetime.now().isoformat()
    })

@app.route('/carpetas')
def carpetas():
    path = request.args.get("path", "")
    try:
        r = requests.get(f"http://127.0.0.1:5052/carpetas?path={path}", timeout=3)
        return r.content, r.status_code, r.headers.items()
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/archivo')
def archivo():
    path = request.args.get("path", "")
    try:
        r = requests.get(f"http://127.0.0.1:5052/archivo?path={path}", timeout=3)
        return r.content, r.status_code, r.headers.items()
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/ia_contexto')
def ia_contexto():
    ia_local = False
    try:
        requests.get("http://127.0.0.1:11434/api/tags", timeout=1)
        ia_local = True
    except:
        pass

    ia_remota = os.path.exists(
        "/data/data/com.termux/files/home/soda/02-SISTEMA/VAULT/REMOTE_IA_KEY"
    )

    return jsonify({
        "ia_local": ia_local,
        "ia_remota": ia_remota,
        "motor_activo": "remota" if ia_remota else ("local" if ia_local else "ninguno"),
        "mensaje": "IA activa" if (ia_local or ia_remota) else "IA no disponible"
    })

@socketio.on('connect')
def connect():
    emit('status', {'message': 'Conectado al Monitor Soberano'})

if __name__ == "__main__":
    socketio.run(app, host="0.0.0.0", port=5050)
