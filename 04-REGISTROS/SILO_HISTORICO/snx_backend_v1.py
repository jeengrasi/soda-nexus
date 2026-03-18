#!/data/data/com.termux/files/usr/bin/python
# ============================================================
# snx_backend_v1.py — Backend soberano v1 para SODA‑NEXUS
# Rol: Proveer estado básico, versión y salud al monitor v1
# Versión: 1.0 — Todo nuevo, nada se modifica
# ============================================================

from flask import Flask, jsonify
import datetime
import os

app = Flask(__name__)

START_TIME = datetime.datetime.utcnow()
VERSION = "SNX-BACKEND-V1.0"

LOG_DIR = os.path.expanduser("~/soda/05-LOGS/BACKEND")
os.makedirs(LOG_DIR, exist_ok=True)
LOG_FILE = os.path.join(LOG_DIR, "backend_v1.log")

def log(msg: str) -> None:
    now = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
    with open(LOG_FILE, "a") as f:
        f.write(f"[{now}] {msg}\n")

@app.route("/ping")
def ping():
    log("PING recibido")
    return jsonify({"status": "ok", "message": "pong", "backend": VERSION})

@app.route("/status")
def status():
    uptime = (datetime.datetime.utcnow() - START_TIME).total_seconds()
    log("STATUS consultado")
    return jsonify({
        "status": "running",
        "version": VERSION,
        "uptime_seconds": int(uptime)
    })

@app.route("/version")
def version():
    log("VERSION consultada")
    return jsonify({"version": VERSION})

@app.route("/health")
def health():
    log("HEALTH check")
    return jsonify({"health": "green"})

if __name__ == "__main__":
    log("Backend v1 iniciando en 0.0.0.0:5050")
    app.run(host="0.0.0.0", port=5050)

# ============================================================
# PIE INSTITUCIONAL — SODA‑NEXUS
# Script backend soberano v1. No modificar sin aprobación.
# No sobrescribir versiones previas. Mantener logs y trazabilidad.
# ============================================================
