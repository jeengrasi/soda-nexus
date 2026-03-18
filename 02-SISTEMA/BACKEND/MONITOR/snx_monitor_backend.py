# ============================================================================
# SNX — BACKEND MONITOR SOBERANO V3
# Ejecución segura de scripts + auditoría extendida + retorno estructurado.
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

# ---------------------------------------------------------------------------
# EJECUCIÓN SEGURA — BACKEND V3
# ---------------------------------------------------------------------------

@app.route("/scripts/ejecutar", methods=["POST"])
def ejecutar():
    inicio = time.time()
    script = request.json.get("script")

    # Cargar allowlist
    with open(os.path.join(os.path.dirname(__file__), "allowed_scripts.json")) as f:
        data = json.load(f)

    if script not in data["allowed"]:
        audit("ejecutar_denegado", {"script": script})
        return jsonify({
            "status": "error",
            "script": script,
            "message": "Script no autorizado",
            "timestamp": time.time()
        }), 403

    rel_path = data["allowed"][script]
    full_path = os.path.join(BASE, rel_path)

    # Validar ruta segura
    if not is_safe(full_path):
        audit("ejecutar_ruta_insegura", {"script": script, "path": full_path})
        return jsonify({
            "status": "error",
            "script": script,
            "message": "Ruta insegura",
            "timestamp": time.time()
        }), 403

    # Validar existencia
    if not os.path.isfile(full_path):
        audit("ejecutar_no_existe", {"script": script, "path": full_path})
        return jsonify({
            "status": "error",
            "script": script,
            "message": "Script no encontrado",
            "timestamp": time.time()
        }), 404

    # Validar permisos
    if not os.access(full_path, os.X_OK):
        audit("ejecutar_no_ejecutable", {"script": script, "path": full_path})
        return jsonify({
            "status": "error",
            "script": script,
            "message": "Script no ejecutable",
            "timestamp": time.time()
        }), 403

    # Ejecución segura
    try:
        proc = subprocess.Popen(
            [full_path],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        stdout, stderr = proc.communicate()
        exit_code = proc.returncode
    except Exception as e:
        audit("ejecutar_error", {"script": script, "error": str(e)})
        return jsonify({
            "status": "error",
            "script": script,
            "message": str(e),
            "timestamp": time.time()
        }), 500

    duracion = time.time() - inicio

    audit("ejecutar", {
        "script": script,
        "exit_code": exit_code,
        "duration": duracion,
        "stdout": stdout,
        "stderr": stderr
    })

    return jsonify({
        "status": "ok" if exit_code == 0 else "error",
        "script": script,
        "output": stdout,
        "error": stderr,
        "exit_code": exit_code,
        "duration": duracion,
        "timestamp": time.time()
    })

# ---------------------------------------------------------------------------
# ENDPOINTS SOBERANOS FASE 3 — INTROSPECCIÓN
# ---------------------------------------------------------------------------

@app.route("/introspect")
def introspect():
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
    socketio.run(app, host="127.0.0.1", port=5051)

# ============================================================================
# SNX — PIE DE PÁGINA INSTITUCIONAL
# Backend soberano v3 — Ejecución segura + auditoría extendida.
# Prohibido modificar a mano; solo mediante fases y scripts aprobados.
# ============================================================================
