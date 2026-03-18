#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# SODA‑NEXUS — FASE 1
# Infraestructura soberana: backend v1 + monitor v1
# Versión: 1.0 (todo nuevo, nada se modifica)
# ============================================================

# [OBS-01] Crear subcarpetas necesarias (sin tocar nada previo)
mkdir -p ~/soda/03-OPERACIONES/BACKEND
mkdir -p ~/soda/06-MONITOR/V1
mkdir -p ~/soda/05-LOGS/BACKEND
mkdir -p ~/soda/05-LOGS/MONITOR

# ------------------------------------------------------------
# [OBS-02] Backend nuevo: snx_backend_v1.py (Flask minimal)
# ------------------------------------------------------------
cat > ~/soda/03-OPERACIONES/BACKEND/snx_backend_v1.py << 'EOF_BACKEND'
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
EOF_BACKEND

chmod +x ~/soda/03-OPERACIONES/BACKEND/snx_backend_v1.py

# ------------------------------------------------------------
# [OBS-03] Servicio backend: snx_backend_v1_service.sh
# ------------------------------------------------------------
cat > ~/soda/02-SISTEMA/DAEMONS/snx_backend_v1_service.sh << 'EOF_SVC'
#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# snx_backend_v1_service.sh — Servicio para backend v1
# Rol: Levantar y mantener el backend v1 con logs
# Versión: 1.0 — Todo nuevo, nada se modifica
# ============================================================

BACKEND_SCRIPT="$HOME/soda/03-OPERACIONES/BACKEND/snx_backend_v1.py"
LOG_FILE="$HOME/soda/05-LOGS/BACKEND/backend_v1_service.log"

mkdir -p "$(dirname "$LOG_FILE")"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Iniciando servicio backend v1"

while true; do
  if [ -f "$BACKEND_SCRIPT" ]; then
    log "Lanzando backend v1..."
    "$BACKEND_SCRIPT" >> "$HOME/soda/05-LOGS/BACKEND/backend_v1_stdout.log" 2>&1
    EXIT_CODE=$?
    log "Backend v1 terminó con código $EXIT_CODE, reiniciando en 5s..."
    sleep 5
  else
    log "ERROR: Backend v1 no encontrado en $BACKEND_SCRIPT"
    sleep 10
  fi
done

# ============================================================
# PIE INSTITUCIONAL — SODA‑NEXUS
# Servicio soberano. No modificar sin aprobación.
# No eliminar logs. Garantizar continuidad y trazabilidad.
# ============================================================
EOF_SVC

chmod +x ~/soda/02-SISTEMA/DAEMONS/snx_backend_v1_service.sh

# ------------------------------------------------------------
# [OBS-04] Monitor v1 — HTML
# ------------------------------------------------------------
cat > ~/soda/06-MONITOR/V1/index-v1.html << 'EOF_HTML'
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <title>SODA‑NEXUS — Monitor v1</title>
  <style>
    body { font-family: system-ui, sans-serif; background: #050816; color: #e5e7eb; margin: 0; padding: 1.5rem; }
    h1 { margin-top: 0; }
    .card { background: #0b1120; border-radius: 0.75rem; padding: 1rem 1.25rem; margin-bottom: 1rem; border: 1px solid #1f2937; }
    .ok { color: #22c55e; }
    .bad { color: #ef4444; }
    code { background: #020617; padding: 0.15rem 0.35rem; border-radius: 0.25rem; }
    button { background: #1d4ed8; color: white; border: none; padding: 0.5rem 0.9rem; border-radius: 0.5rem; cursor: pointer; }
    button:hover { background: #2563eb; }
    .row { display: flex; gap: 1rem; flex-wrap: wrap; }
    .row > div { flex: 1 1 260px; }
  </style>
</head>
<body>
  <h1>SODA‑NEXUS — Monitor v1</h1>
  <div class="card">
    <p>Backend objetivo: <code>http://127.0.0.1:5050</code> (preparado para Tor en Fase 2)</p>
    <button onclick="refreshAll()">Actualizar estado</button>
  </div>

  <div class="row">
    <div class="card" id="status-card">
      <h2>Estado backend</h2>
      <pre id="status-output">Sin datos aún…</pre>
    </div>
    <div class="card" id="version-card">
      <h2>Versión</h2>
      <pre id="version-output">Sin datos aún…</pre>
    </div>
  </div>

  <div class="card">
    <h2>Health</h2>
    <pre id="health-output">Sin datos aún…</pre>
  </div>

  <script src="./monitor-v1.js"></script>
</body>
</html>
EOF_HTML

# ------------------------------------------------------------
# [OBS-05] Monitor v1 — JS
# ------------------------------------------------------------
cat > ~/soda/06-MONITOR/V1/monitor-v1.js << 'EOF_JS'
const BASE_URL = "http://127.0.0.1:5050";

async function fetchJSON(path) {
  const url = `${BASE_URL}${path}`;
  try {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    return await res.json();
  } catch (err) {
    return { error: true, message: err.message, url };
  }
}

async function refreshStatus() {
  const el = document.getElementById("status-output");
  const data = await fetchJSON("/status");
  el.textContent = JSON.stringify(data, null, 2);
}

async function refreshVersion() {
  const el = document.getElementById("version-output");
  const data = await fetchJSON("/version");
  el.textContent = JSON.stringify(data, null, 2);
}

async function refreshHealth() {
  const el = document.getElementById("health-output");
  const data = await fetchJSON("/health");
  el.textContent = JSON.stringify(data, null, 2);
}

async function refreshAll() {
  await Promise.all([refreshStatus(), refreshVersion(), refreshHealth()]);
}

window.addEventListener("load", () => {
  refreshAll();
});
EOF_JS

# ------------------------------------------------------------
# [OBS-06] Registro de Fase 1
# ------------------------------------------------------------
echo "[FASE 1] Infraestructura v1 creada el $(date)" >> ~/soda/05-LOGS/FASE1.log

# ============================================================
# PIE INSTITUCIONAL — SODA‑NEXUS
# FASE 1: Infraestructura soberana v1 (backend + monitor).
# No modificar sin aprobación. No sobrescribir versiones previas.
# Este script solo crea, nunca destruye.
# ============================================================
