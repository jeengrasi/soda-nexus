#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — UPGRADE BACKEND MONITOR V2 (FASE 3)
# Genera un backend completo v2 y reemplaza el actual con backup.
# ============================================================================

BACKEND_DIR="$HOME/soda/02-SISTEMA/BACKEND/MONITOR"
BACKEND_FILE="$BACKEND_DIR/snx_monitor_backend.py"
BACKEND_BAK="$BACKEND_DIR/snx_monitor_backend.py.bak.$(date +%Y%m%d-%H%M%S)"
BACKEND_V2="$BACKEND_DIR/snx_monitor_backend_v2.py"

echo "[SNX] Generando backend v2 completo en: $BACKEND_V2"

cat > "$BACKEND_V2" << 'EOF_PY'
# ============================================================================
# SNX — BACKEND MONITOR SOBERANO V2
# Backend Flask + SocketIO para el Monitor Soberano.
# Incluye endpoints originales + introspección soberana de FASE 3.
# ============================================================================

from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_socketio import SocketIO, emit
import os, subprocess, json, time

from path_security import is_safe
from audit_logger import audit
from ia_engine import diagnostico_completo
from integridad_engine import auditoria_integridad
from deploy_engine import estado_publicacion

BASE = os.path.expanduser("~/soda")
SERVICE_ROOT = "/data/data/com.termux/files/usr/var/service"

app = Flask(__name__)
CORS(app)
socketio = SocketIO(app, cors_allowed_origins="*", async_mode="eventlet")

# ---------------------------------------------------------------------------
# ENDPOINTS ORIGINALES
# ---------------------------------------------------------------------------

@app.route("/estado")
def estado():
    audit("estado", {})
    return jsonify({"status": "online", "timestamp": time.time()})

@app.route("/carpetas")
def carpetas():
    path = request.args.get("path", "")
    full = os.path.join(BASE, path)
    if not is_safe(full):
        return jsonify({"error": "Acceso denegado"}), 403
    items = []
    for item in os.listdir(full):
        p = os.path.join(full, item)
        items.append({"name": item, "type": "dir" if os.path.isdir(p) else "file"})
    audit("carpetas", {"path": path})
    return jsonify({"path": path, "items": items})

@app.route("/archivo")
def archivo():
    path = request.args.get("path")
    full = os.path.join(BASE, path)
    if not is_safe(full):
        return jsonify({"error": "Acceso denegado"}), 403
    with open(full, "r", errors="ignore") as f:
        content = f.read()
    audit("archivo", {"path": path})
    return jsonify({"content": content})

@app.route("/procesos")
def procesos():
    out = subprocess.getoutput("ps -A")
    audit("procesos", {})
    return jsonify({"procesos": out})

@app.route("/logs")
def logs():
    path = request.args.get("path")
    full = os.path.join(BASE, path)
    if not is_safe(full):
        return jsonify({"error": "Acceso denegado"}), 403
    with open(full, "r", errors="ignore") as f:
        lines = f.readlines()[-200:]
    audit("logs", {"path": path})
    return jsonify({"lines": lines})

@socketio.on("stream_logs")
def stream_logs(data):
    path = data.get("path")
    full = os.path.join(BASE, path)
    if not is_safe(full):
        emit("logs", {"error": "Acceso denegado"})
        return
    audit("ws_logs", {"path": path})
    proc = subprocess.Popen(["tail", "-f", full], stdout=subprocess.PIPE)
    for line in iter(proc.stdout.readline, b""):
        emit("logs", {"line": line.decode()})

@app.route("/scripts")
def scripts():
    with open(os.path.join(os.path.dirname(__file__), "allowed_scripts.json")) as f:
        data = json.load(f)
    audit("scripts", {})
    return jsonify(data["allowed"])

@app.route("/scripts/ejecutar", methods=["POST"])
def ejecutar():
    script = request.json.get("script")
    with open(os.path.join(os.path.dirname(__file__), "allowed_scripts.json")) as f:
        data = json.load(f)
    if script not in data["allowed"]:
        return jsonify({"error": "Script no autorizado"}), 403
    path = os.path.join(BASE, data["allowed"][script])
    out = subprocess.getoutput(path)
    audit("ejecutar", {"script": script})
    return jsonify({"output": out})

@app.route("/ia/diagnostico")
def ia_diagnostico():
    data = diagnostico_completo()
    audit("ia_diagnostico", {})
    return jsonify(data)

@app.route("/auditoria/integridad")
def auditoria():
    data = auditoria_integridad()
    audit("auditoria_integridad", {})
    return jsonify(data)

@app.route("/deploy/estado")
def deploy_estado():
    data = estado_publicacion()
    audit("deploy_estado", {})
    return jsonify(data)

# ---------------------------------------------------------------------------
# ENDPOINTS SOBERANOS FASE 3 — INTROSPECCIÓN COMPLETA
# ---------------------------------------------------------------------------

@app.route("/introspect")
def introspect():
    """Mapa soberano del sistema: carpetas, procesos snx_, servicios runit."""
    audit("introspect", {})
    try:
        carpetas = os.listdir(BASE)
    except Exception as e:
        carpetas = [f"ERROR_LISTAR_SODA: {e}"]

    try:
        servicios = os.listdir(SERVICE_ROOT)
    except Exception as e:
        servicios = [f"ERROR_LISTAR_SERVICIOS: {e}"]

    procesos_snx = subprocess.getoutput("ps aux | grep snx_ | grep -v grep")

    data = {
        "timestamp": time.time(),
        "soda_root": BASE,
        "carpetas": carpetas,
        "servicios_runit": servicios,
        "procesos_snx": procesos_snx,
    }
    return jsonify(data)

@app.route("/estructura")
def estructura():
    """Estructura detallada de una ruta dentro de ~/soda."""
    path = request.args.get("path", "")
    full = os.path.join(BASE, path)
    if not is_safe(full):
        return jsonify({"error": "Acceso denegado"}), 403

    items = []
    try:
        for item in os.listdir(full):
            p = os.path.join(full, item)
            try:
                size = os.path.getsize(p)
                perms = oct(os.stat(p).st_mode)[-3:]
            except Exception:
                size = -1
                perms = "???"
            items.append({
                "name": item,
                "type": "dir" if os.path.isdir(p) else "file",
                "size": size,
                "permisos": perms
            })
    except Exception as e:
        return jsonify({"error": f"No se pudo listar: {e}"}), 500

    audit("estructura", {"path": path})
    return jsonify({"path": path, "items": items})

@app.route("/estado_extendido")
def estado_extendido():
    """Estado extendido del sistema: blindaje, guardian, procesos, snx_state."""
    audit("estado_extendido", {})
    estado = {
        "timestamp": time.time(),
        "backend": "online",
        "blindaje": subprocess.getoutput("sv status snx_termux_blindaje"),
        "guardian": subprocess.getoutput("ps aux | grep snx_guardian_soberano | grep -v grep"),
        "procesos_snx": subprocess.getoutput("ps aux | grep snx_ | grep -v grep"),
    }

    state_file = os.path.expanduser("~/soda/00-GOBIERNO/ESTADO/snx_state.json")
    if os.path.exists(state_file):
        try:
            with open(state_file, "r") as f:
                estado["snx_state"] = json.load(f)
        except Exception as e:
            estado["snx_state_error"] = str(e)

    return jsonify(estado)

# ---------------------------------------------------------------------------
# MAIN
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    # OBS: El backend escucha solo en localhost; el acceso externo lo maneja el Monitor.
    socketio.run(app, host="127.0.0.1", port=5051)

# ============================================================================
# SNX — PIE DE PÁGINA INSTITUCIONAL
# Este backend pertenece al BACKEND soberano del Monitor.
# Prohibido modificar a mano; solo mediante fases y scripts aprobados.
# ============================================================================
EOF_PY

echo "[SNX] Backend v2 generado. Creando backup del backend actual..."

if [ -f "$BACKEND_FILE" ]; then
  mv "$BACKEND_FILE" "$BACKEND_BAK"
  echo "[SNX] Backup creado: $BACKEND_BAK"
fi

mv "$BACKEND_V2" "$BACKEND_FILE"
echo "[SNX] Backend v2 activado: $BACKEND_FILE"

echo "[SNX] Validando sintaxis de Python..."
python -m py_compile "$BACKEND_FILE"
echo "[SNX] Sintaxis OK."

echo "[SNX] FASE 3 — UPGRADE COMPLETADO."
# ============================================================================
# SNX — PIE DE PÁGINA INSTITUCIONAL (SCRIPT)
# FASE: 3 — Exposición del Backend al Monitor (upgrade v2 completo)
# No editar este script a mano. Usar siempre fases y nuevos scripts.
# ============================================================================
