import os, subprocess, time

BASE = os.path.expanduser("~/soda")
REPO_PATH_FILE = os.path.join(BASE, "02-SISTEMA/BACKEND/MONITOR/REPO_PATH.txt")

def leer_repo():
    if not os.path.exists(REPO_PATH_FILE):
        return None
    with open(REPO_PATH_FILE, "r") as f:
        return f.read().strip()

def verificar_archivos(repo):
    archivos = {
        "index": os.path.exists(os.path.join(repo, "docs/index.html")),
        "monitor_js": os.path.exists(os.path.join(repo, "docs/monitor.js")),
        "ia_js": os.path.exists(os.path.join(repo, "docs/ia.js")),
    }
    return archivos

def verificar_git(repo):
    remoto = subprocess.getoutput(f"cd {repo} && git remote get-url origin")
    pendientes = subprocess.getoutput(f"cd {repo} && git status --porcelain")
    return remoto, pendientes

def estado_publicacion():
    repo = leer_repo()
    if not repo:
        return {"error": "No hay repositorio seleccionado"}

    archivos = verificar_archivos(repo)
    remoto, pendientes = verificar_git(repo)

    estado = "OK"
    if not archivos["index"]:
        estado = "FALTA_INDEX"
    if pendientes.strip():
        estado = "CAMBIOS_PENDIENTES"

    return {
        "timestamp": time.time(),
        "repo": repo,
        "archivos_publicacion": archivos,
        "git_remoto": remoto,
        "git_pendientes": pendientes.splitlines(),
        "estado_publicacion": estado
    }
