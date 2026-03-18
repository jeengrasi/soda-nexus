from flask import Flask, jsonify, request, send_from_directory
import os, json, requests, traceback
from datetime import datetime
app = Flask(__name__, static_url_path='', static_folder='static')

@app.route('/')
def index(): return app.send_static_file('index.html')

BASE = os.path.expanduser("~/soda")
REG_IA = os.path.join(BASE, "04-REGISTROS", "ia_sesiones")
VAULT_DIR = os.path.join(BASE, "02-SISTEMA", "VAULT")

VAULT_LOCAL_MODEL = os.path.join(VAULT_DIR, "LOCAL_IA_MODEL")
VAULT_REMOTE_URL = os.path.join(VAULT_DIR, "REMOTE_IA_URL")
VAULT_REMOTE_MODEL = os.path.join(VAULT_DIR, "REMOTE_IA_MODEL")
VAULT_REMOTE_KEY = os.path.join(VAULT_DIR, "REMOTE_IA_KEY")
VAULT_CURRENT_MOTOR = os.path.join(VAULT_DIR, "CURRENT_MOTOR.json")

os.makedirs(REG_IA, exist_ok=True)


# ---------- utilidades básicas ----------

def load_text(path):
    try:
        with open(path, "r", encoding="utf-8") as f:
            return f.read().strip()
    except:
        return None

def save_text(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

def load_json(path, default=None):
    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except:
        return default

def save_json(path, data):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

def safe_path_soda(rel_path):
    """
    Normaliza y asegura que la ruta esté dentro de ~/soda.
    Recibe algo tipo /soda/03-OPERACIONES/archivo.txt
    """
    if not rel_path.startswith("/soda"):
        raise ValueError("Ruta fuera de /soda no permitida")
    base = os.path.expanduser("~/soda")
    full = rel_path.replace("/soda", base, 1)
    full_real = os.path.realpath(full)
    if not full_real.startswith(base):
        raise ValueError("Ruta escapando de /soda no permitida")
    return full_real

# ---------- lectura de VAULTs ----------

def get_local_model():
    return load_text(VAULT_LOCAL_MODEL)

def get_remote_config():
    url = load_text(VAULT_REMOTE_URL)
    model = load_text(VAULT_REMOTE_MODEL)
    key = load_text(VAULT_REMOTE_KEY)
    if not url or not model:
        return None, None, None
    return url, model, key

def update_current_motor(motor, modelo):
    data = {
        "motor": motor,
        "modelo": modelo,
        "timestamp": datetime.utcnow().isoformat() + "Z"
    }
    save_json(VAULT_CURRENT_MOTOR, data)

# ---------- endpoints básicos de sistema ----------

@app.route("/ping_v4")
def ping_v4():
    return jsonify({
        "status": "ok",
        "message": "SODA-NEXUS Orquestador V4 activo"
    })

@app.route("/health")
def health():
    local_model = get_local_model()
    url, model, key = get_remote_config()
    return jsonify({
        "status": "ok",
        "local_model": bool(local_model),
        "remote_config": bool(url and model)
    })

@app.route("/archivo")
def archivo():
    path = request.args.get("path", "")
    try:
        full = safe_path_soda(path)
        try:
            with open(full, "r", encoding="utf-8") as f:
                contenido = f.read()
        except:
            contenido = ""
        return jsonify({"status": "ok", "path": path, "contenido": contenido})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 400

@app.route("/carpeta")
def carpeta():
    path = request.args.get("path", "/soda")
    try:
        full = safe_path_soda(path)
        try:
            contenido = sorted(os.listdir(full))
        except:
            contenido = []
        return jsonify({"status": "ok", "path": path, "contenido": contenido})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 400

@app.route("/arbol")
def arbol():
    path = request.args.get("path", "/soda")
    try:
        full = safe_path_soda(path)
        tree = {}
        base = os.path.expanduser("~/soda")
        for root, dirs, files in os.walk(full):
            rel = root.replace(base, "/soda", 1)
            tree[rel] = {"dirs": sorted(dirs), "files": sorted(files)}
        return jsonify({"status": "ok", "path": path, "arbol": tree})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 400

@app.route("/buscar")
def buscar():
    nombre = request.args.get("nombre", "").lower()
    if not nombre:
        return jsonify({"status": "error", "message": "Parámetro 'nombre' requerido"}), 400
    resultados = []
    base = os.path.expanduser("~/soda")
    for root, dirs, files in os.walk(base):
        for f in files:
            if nombre in f.lower():
                rel_dir = root.replace(base, "/soda", 1)
                resultados.append(os.path.join(rel_dir, f))
    return jsonify({"status": "ok", "nombre": nombre, "resultados": resultados})

# ---------- implementación de herramientas (Protocolo) ----------

def herramienta_leer_archivo(params):
    ruta = params.get("ruta")
    full = safe_path_soda(ruta)
    with open(full, "r", encoding="utf-8") as f:
        contenido = f.read()
    return {"exito": True, "resultado": contenido, "error": None}

def herramienta_listar_carpeta(params):
    ruta = params.get("ruta")
    full = safe_path_soda(ruta)
    contenido = sorted(os.listdir(full))
    return {"exito": True, "resultado": contenido, "error": None}

def herramienta_arbol(params):
    ruta = params.get("ruta")
    full = safe_path_soda(ruta)
    base = os.path.expanduser("~/soda")
    tree = {}
    for root, dirs, files in os.walk(full):
        rel = root.replace(base, "/soda", 1)
        tree[rel] = {"dirs": sorted(dirs), "files": sorted(files)}
    return {"exito": True, "resultado": tree, "error": None}

def herramienta_buscar_archivo(params):
    nombre = (params.get("nombre") or "").lower()
    if not nombre:
        return {"exito": False, "resultado": None, "error": "nombre vacío"}
    base = os.path.expanduser("~/soda")
    resultados = []
    for root, dirs, files in os.walk(base):
        for f in files:
            if nombre in f.lower():
                rel_dir = root.replace(base, "/soda", 1)
                resultados.append(os.path.join(rel_dir, f))
    return {"exito": True, "resultado": resultados, "error": None}

def herramienta_leer_log(params):
    ruta = params.get("ruta")
    lineas = int(params.get("lineas", 50))
    full = safe_path_soda(ruta)
    try:
        with open(full, "r", encoding="utf-8") as f:
            all_lines = f.readlines()
        tail = "".join(all_lines[-lineas:])
    except:
        tail = ""
    return {"exito": True, "resultado": tail, "error": None}

# externas: aquí solo definimos interfaz; implementación real depende del servidor remoto
def herramienta_buscar_web(params):
    # El orquestador puede delegar esto a IA remota o a un servicio propio.
    return {"exito": False, "resultado": None, "error": "buscar_web no implementado en este backend"}

def herramienta_consultar_api(params):
    return {"exito": False, "resultado": None, "error": "consultar_api no implementado en este backend"}

HERRAMIENTAS = {
    "leer_archivo": herramienta_leer_archivo,
    "listar_carpeta": herramienta_listar_carpeta,
    "arbol": herramienta_arbol,
    "buscar_archivo": herramienta_buscar_archivo,
    "leer_log": herramienta_leer_log,
    "buscar_web": herramienta_buscar_web,
    "consultar_api": herramienta_consultar_api,
}

@app.route("/herramienta", methods=["POST"])
def herramienta():
    data = request.get_json(silent=True) or {}
    nombre = data.get("herramienta")
    params = data.get("parametros", {})
    if nombre not in HERRAMIENTAS:
        return jsonify({"exito": False, "resultado": None, "error": f"Herramienta desconocida: {nombre}"}), 400
    try:
        res = HERRAMIENTAS[nombre](params)
        return jsonify(res)
    except Exception as e:
        return jsonify({"exito": False, "resultado": None, "error": str(e)}), 500

# ---------- llamadas a IA local y remota ----------

def llamar_ia_local(instruccion, contexto):
    modelo = get_local_model()
    if not modelo:
        return None, "Modelo local no configurado en VAULT"

    try:
        resp = requests.post(
            "http://127.0.0.1:11434/api/chat",
            headers={"Content-Type": "application/json"},
            json={
                "model": modelo,
                "messages": [
                    {
                        "role": "system",
                        "content": (
                            "Eres la IA LOCAL de SODA-NEXUS. "
                            "No ejecutas comandos. Solo analizas, propones y documentas. "
                            "Puedes pedir herramientas al Orquestador usando el protocolo definido."
                        )
                    },
                    {
                        "role": "user",
                        "content": instruccion
                    }
                ],
                "stream": False
            },
            timeout=120
        )
        data = resp.json()
        update_current_motor("local", modelo)
        if "message" in data and "content" in data["message"]:
            return data["message"]["content"].strip(), None
        if "choices" in data:
            msg = data["choices"][0].get("message", {}).get("content", "")
            return msg.strip(), None
        return None, f"Respuesta inesperada de IA local. HTTP {resp.status_code}"
    except Exception as e:
        return None, f"Error al contactar IA local: {str(e)}"

def llamar_ia_remota(instruccion, contexto):
    url, modelo, key = get_remote_config()
    if not url or not modelo:
        return None, "IA remota no configurada en VAULT"

    headers = {"Content-Type": "application/json"}
    if key:
        headers["Authorization"] = f"Bearer {key}"

    try:
        resp = requests.post(
            url,
            headers=headers,
            json={
                "model": modelo,
                "messages": [
                    {
                        "role": "system",
                        "content": (
                            "Eres la IA REMOTA de SODA-NEXUS. "
                            "Tienes acceso a herramientas externas (web, APIs) a través de tu propio entorno. "
                            "No ejecutas comandos en Termux. "
                            "Puedes pedir herramientas internas al Orquestador usando el protocolo definido."
                        )
                    },
                    {
                        "role": "user",
                        "content": instruccion
                    }
                ]
            },
            timeout=120
        )
        data = resp.json()
        update_current_motor("remota", modelo)
        if "choices" in data:
            msg = data["choices"][0].get("message", {}).get("content", "")
            return msg.strip(), None
        if "message" in data and "content" in data["message"]:
            return data["message"]["content"].strip(), None
        return None, f"Respuesta inesperada de IA remota. HTTP {resp.status_code}"
    except Exception as e:
        return None, f"Error al contactar IA remota: {str(e)}"

# ---------- lógica de elección de motor ----------

def elegir_motor(instruccion, contexto):
    ctx = contexto if isinstance(contexto, dict) else {}
    if ctx.get("forzar_remota"):
        return "remota"
    if ctx.get("forzar_local"):
        return "local"

    texto = (instruccion or "").lower()

    palabras_remota = [
        "internet", "web", "noticia", "noticias",
        "api externa", "broker", "mercado", "economía",
        "buscar en google", "buscar en la web"
    ]
    palabras_local = [
        "archivo", "carpeta", "motor", "desviación",
        "/soda/", "vault", "logs", "registro"
    ]

    # auditoría crítica: siempre local
    criticas = ["borrar", "eliminar", "transferencia", "orden de trading", "ejecutar script"]
    if any(p in texto for p in criticas):
        return "local"

    if any(p in texto for p in palabras_remota):
        return "remota"
    if any(p in texto for p in palabras_local):
        return "local"

    # default soberano
    return "local"

# ---------- endpoint principal para el monitor ----------

@app.route("/ia_ejecutar", methods=["POST"])
def ia_ejecutar():
    data = request.get_json(silent=True) or {}
    instruccion = (data.get("instruccion") or "").strip()
    contexto = data.get("contexto", {})

    if not instruccion:
        return jsonify({"status": "error", "message": "Instrucción vacía"}), 400

    motor = elegir_motor(instruccion, contexto)
    respuesta_ia = None
    detalle = ""

    if motor == "remota":
        respuesta_ia, error_remota = llamar_ia_remota(instruccion, contexto)
        if respuesta_ia is None:
            detalle += f"[Fallo IA remota: {error_remota}]\n"
            respuesta_ia, error_local = llamar_ia_local(instruccion, contexto)
            if respuesta_ia is None:
                detalle += f"[Fallo IA local: {error_local}]"
                respuesta_ia = (
                    "No se pudo usar ni IA remota ni IA local.\n"
                    f"Detalle: {detalle}"
                )
    else:
        respuesta_ia, error_local = llamar_ia_local(instruccion, contexto)
        if respuesta_ia is None:
            detalle += f"[Fallo IA local: {error_local}]\n"
            respuesta_ia, error_remota = llamar_ia_remota(instruccion, contexto)
            if respuesta_ia is None:
                detalle += f"[Fallo IA remota: {error_remota}]"
                respuesta_ia = (
                    "No se pudo usar ni IA local ni IA remota.\n"
                    f"Detalle: {detalle}"
                )

    ts = datetime.utcnow().strftime("%Y-%m-%d_%H%M%S")
    os.makedirs(REG_IA, exist_ok=True)
    sesion_path = os.path.join(REG_IA, f"{ts}_ia_sesion.json")

    registro = {
        "timestamp": ts,
        "instruccion": instruccion,
        "contexto": contexto,
        "motor_elegido": motor,
        "respuesta": respuesta_ia
    }

    save_json(sesion_path, registro)

    return jsonify({
        "status": "ok",
        "sesion_guardada": sesion_path.replace(os.path.expanduser("~/soda"), "/soda", 1),
        "respuesta": respuesta_ia
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=15051)
