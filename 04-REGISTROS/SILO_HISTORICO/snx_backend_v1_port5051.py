#!/data/data/com.termux/files/usr/bin/python
from flask import Flask, jsonify
import datetime, os

app = Flask(__name__)
START_TIME = datetime.datetime.utcnow()
VERSION = "SNX-BACKEND-V1.0 (PORT 5051)"

LOG_DIR = os.path.expanduser("~/soda/05-LOGS/BACKEND")
os.makedirs(LOG_DIR, exist_ok=True)
LOG_FILE = os.path.join(LOG_DIR, "backend_v1_port5051.log")

def log(msg):
    now = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
    with open(LOG_FILE, "a") as f:
        f.write(f"[{now}] {msg}\n")

@app.route("/status")
def status():
    uptime = (datetime.datetime.utcnow() - START_TIME).total_seconds()
    log("STATUS consultado")
    return jsonify({"status": "running", "version": VERSION, "uptime": int(uptime)})

@app.route("/version")
def version():
    log("VERSION consultada")
    return jsonify({"version": VERSION})

@app.route("/health")
def health():
    log("HEALTH consultado")
    return jsonify({"health": "green"})

@app.route("/ping")
def ping():
    log("PING recibido")
    return jsonify({"status": "ok", "backend": VERSION})

if __name__ == "__main__":
    log("Backend v1 iniciando en 0.0.0.0:5051")
    app.run(host="0.0.0.0", port=5051)
