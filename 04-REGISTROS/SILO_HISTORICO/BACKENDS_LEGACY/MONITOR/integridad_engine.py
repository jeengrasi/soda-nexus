import os, time, hashlib, json

BASE = os.path.expanduser("~/soda")

ARCHIVOS_CRITICOS = [
    "02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend.py",
    "02-SISTEMA/BACKEND/MONITOR/ia_engine.py",
    "02-SISTEMA/BACKEND/MONITOR/integridad_engine.py",
    "06-DOCUMENTACION/MONITOR/CONTEXTO-GENERAL.md",
]

LOGS_CLAVE = [
    "05-LOGS/MONITOR/",
    "05-LOGS/TUNNEL/",
]

SCRIPTS_REGISTRADOS = [
    "02-SCRIPTS/GLOBAL/snx_detect_repos.sh",
    "02-SCRIPTS/GLOBAL/snx_select_repo.sh",
    "02-SCRIPTS/GLOBAL/snx_publish_monitor.sh",
    "02-SCRIPTS/GLOBAL/snx_ia_diagnostico.sh",
]

def hash_archivo(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            h.update(chunk)
    return h.hexdigest()

def verificar_archivos_criticos():
    resultados = []
    for rel in ARCHIVOS_CRITICOS:
        full = os.path.join(BASE, rel)
        if not os.path.exists(full):
            resultados.append({"archivo": rel, "estado": "NO_EXISTE"})
        else:
            resultados.append({"archivo": rel, "estado": "OK", "hash": hash_archivo(full)})
    return resultados

def verificar_logs():
    faltantes = []
    for rel in LOGS_CLAVE:
        full = os.path.join(BASE, rel)
        if not os.path.exists(full):
            faltantes.append(rel)
    return faltantes

def verificar_scripts():
    no_registrados = []
    for rel in SCRIPTS_REGISTRADOS:
        full = os.path.join(BASE, rel)
        if not os.path.exists(full):
            no_registrados.append(rel)
    return no_registrados

def auditoria_integridad():
    return {
        "timestamp": time.time(),
        "archivos_criticos": verificar_archivos_criticos(),
        "logs_faltantes": verificar_logs(),
        "scripts_no_registrados": verificar_scripts(),
    }
