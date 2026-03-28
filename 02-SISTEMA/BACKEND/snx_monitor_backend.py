# SNX — BACKEND INSTITUCIONAL DEL MONITOR 2026  # OBS: Encabezado institucional obligatorio.

from flask import Flask, jsonify  # OBS: Importa Flask para crear API HTTP.
import os                         # OBS: Permite leer el filesystem real.
import time                       # OBS: Permite obtener fechas de modificación.
import subprocess                 # OBS: Permite ejecutar comandos del sistema.

app = Flask(__name__)             # OBS: Inicializa la aplicación Flask.

BASE = "/data/data/com.termux/files/home/soda"  # OBS: Ruta soberana del sistema.

# OBS: Lista de carpetas oficiales del sistema.
OFICIALES = [
    "00-GOBIERNO",
    "01-MEMORIA",
    "02-SISTEMA",
    "03-OPERACIONES",
    "04-REGISTROS",
    "05-DOCUMENTACION",
    "99-TMP"
]

# OBS: Carpetas críticas que requieren vigilancia especial.
CRITICAS = [
    "00-GOBIERNO",
    "02-SISTEMA",
    "04-REGISTROS"
]

def clasificar(nombre, ruta_completa):  # OBS: Función que clasifica cada carpeta.
    if nombre in OFICIALES:             # OBS: Si está en la lista oficial.
        estado = "oficial"              # OBS: Estado institucional correcto.
    else:
        estado = "sospechosa"           # OBS: Carpeta fuera de norma.

    if nombre in CRITICAS:              # OBS: Si es carpeta crítica.
        riesgo = "alto"                 # OBS: Riesgo alto.
    elif estado == "sospechosa":        # OBS: Si es sospechosa.
        riesgo = "medio"                # OBS: Riesgo medio.
    else:
        riesgo = "bajo"                 # OBS: Riesgo bajo.

    existe = os.path.exists(ruta_completa)  # OBS: Verifica existencia real.
    vacia = False                           # OBS: Inicializa bandera de vacío.

    if existe and os.path.isdir(ruta_completa):               # OBS: Si es carpeta válida.
        vacia = len(os.listdir(ruta_completa)) == 0           # OBS: Detecta si está vacía.

    return estado, riesgo, existe, vacia                      # OBS: Devuelve clasificación.

def scan_folder(path):                                        # OBS: Escanea la carpeta raíz.
    items = []                                                # OBS: Lista de elementos encontrados.

    for name in os.listdir(path):                             # OBS: Itera sobre cada elemento.
        full = os.path.join(path, name)                       # OBS: Construye ruta completa.
        info = os.stat(full)                                  # OBS: Obtiene metadata del archivo.

        estado, riesgo, existe, vacia = clasificar(name, full)  # OBS: Clasifica carpeta.

        items.append({                                        # OBS: Agrega información al JSON.
            "name": name,
            "path": full,
            "type": "folder" if os.path.isdir(full) else "file",
            "size": info.st_size,
            "modified": time.ctime(info.st_mtime),
            "estado": estado,
            "riesgo": riesgo,
            "existe": existe,
            "vacia": vacia
        })

    fantasmas = []                                            # OBS: Lista de carpetas fantasma.

    for carpeta in OFICIALES:                                 # OBS: Revisa cada carpeta oficial.
        ruta = os.path.join(BASE, carpeta)                    # OBS: Construye ruta completa.
        if not os.path.exists(ruta):                          # OBS: Si no existe en el filesystem.
            fantasmas.append({
                "name": carpeta,
                "path": ruta,
                "estado": "fantasma",
                "riesgo": "alto",
                "existe": False
            })

    return {                                                  # OBS: Devuelve estructura completa.
        "carpetas": items,
        "fantasmas": fantasmas
    }

@app.route("/folders")                                        # OBS: Endpoint principal del monitor.
def folders():
    return jsonify(scan_folder(BASE))                         # OBS: Devuelve JSON con clasificación.

@app.route("/status")                                         # OBS: Endpoint para ver estado del backend.
def status():
    return jsonify({
        "status": "activo",
        "backend": True,
        "validador": os.path.exists("/data/data/com.termux/files/home/soda/02-SISTEMA/snx_validador.sh"),
        "timestamp": time.ctime()
    })

@app.route("/activar_validador")                              # OBS: Endpoint para activar validador.
def activar_validador():
    try:
        subprocess.Popen(["bash", "/data/data/com.termux/files/home/soda/02-SISTEMA/snx_validador.sh"])
        return jsonify({"status": "validador activado"})
    except Exception as e:
        return jsonify({"error": str(e)})

@app.route("/restart_backend")                                # OBS: Endpoint para reiniciar backend.
def restart_backend():
    try:
        subprocess.Popen(["pkill", "-f", "snx_monitor_backend.py"])
        subprocess.Popen(["python", "/data/data/com.termux/files/home/soda/02-SISTEMA/BACKEND/snx_monitor_backend.py"])
        return jsonify({"status": "backend reiniciado"})
    except Exception as e:
        return jsonify({"error": str(e)})

@app.route("/")                                               # OBS: Endpoint raíz.
def root():
    return jsonify({"status": "SNX Monitor Backend activo con clasificación institucional"})

if __name__ == "__main__":                                    # OBS: Punto de entrada del backend.
    app.run(host="0.0.0.0", port=5000)                        # OBS: Inicia servidor Flask.

# --------------------------------------------------------------
# SNX — PIE DE PÁGINA INSTITUCIONAL (VERSIÓN OFICIAL 2026)
# Este script pertenece al sistema soberano SODA‑NEXUS.
#
# ESTRUCTURA SOBERANA:
# 00-GOBIERNO, 01-MEMORIA, 02-SISTEMA,
# 03-OPERACIONES, 04-REGISTROS, 05-DOCUMENTACION, 99-TMP.
#
# REGLAS INSTITUCIONALES:
# 1. Antes de modificar, SIEMPRE inspeccionar el filesystem real.
# 2. No crear carpetas nuevas sin aprobación institucional.
# 3. No eliminar archivos sin clasificación previa.
# 4. No sobrescribir scripts sin diagnóstico y evidencia.
# 5. Todas las tareas deben ejecutarse en el MISMO chat para evitar amnesia.
# 6. Cada línea del script debe incluir observaciones [OBS].
# 7. Todo script debe ser auditable, reversible y sin efectos colaterales.
# 8. VAULT, ESTADO y REGISTROS son carpetas CRÍTICAS.
# 9. Ningún script debe depender de servicios externos sin aprobación.
# 10. Todo cambio debe registrarse en snx_state.json (cuando exista IA‑SCRIPT CENTRAL).
#
# REGLAS DE AUDITORÍA:
# - Detectar carpetas fantasma (referenciadas pero inexistentes).
# - Detectar carpetas sospechosas (fuera de la estructura soberana).
# - Detectar carpetas vacías inesperadas.
# - Detectar rutas rotas o scripts heredados.
# - Reportar anomalías antes de actuar.
#
# REGLAS DE DOCUMENTACIÓN:
# - Cada script debe incluir encabezado, observaciones y pie de página.
# - Cada línea debe explicar su propósito con [OBS].
# - Ningún script debe contener lógica oculta o ambigua.
# --------------------------------------------------------------

# ============================================================
# ENDPOINT PARA LOGS REALES
# ============================================================

@app.route('/logs')
def get_logs():
    """Devuelve los últimos logs del sistema desde 04-REGISTROS/SYSTEM/"""
    import glob
    log_dir = f"{BASE}/04-REGISTROS/SYSTEM"
    logs = []
    
    # Buscar archivos de log recientes
    log_files = glob.glob(f"{log_dir}/*.log")
    log_files.sort(key=lambda x: os.path.getmtime(x), reverse=True)
    
    for log_file in log_files[:5]:  # Últimos 5 archivos
        try:
            with open(log_file, 'r') as f:
                lines = f.readlines()[-5:]  # Últimas 5 líneas de cada archivo
                for line in lines:
                    if line.strip():
                        logs.append(line.strip())
        except:
            pass
    
    return jsonify({"logs": logs[-20:]})  # Últimas 20 líneas en total
