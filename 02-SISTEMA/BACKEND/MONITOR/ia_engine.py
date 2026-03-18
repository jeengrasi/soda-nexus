import os, time

BASE = os.path.expanduser("~/soda")

def analizar_carpetas():
    problemas = []
    for root, dirs, files in os.walk(BASE):
        if len(files) > 500:
            problemas.append(f"Carpeta con demasiados archivos: {root}")
        if "tmp" in root.lower() and len(files) > 100:
            problemas.append(f"Acumulación en carpeta temporal: {root}")
    return problemas

def analizar_procesos():
    out = os.popen("ps -A").read()
    riesgos = []
    if "python" not in out:
        riesgos.append("No hay procesos Python activos.")
    if out.count("python") > 10:
        riesgos.append("Demasiados procesos Python simultáneos.")
    return riesgos

def analizar_logs():
    log_dir = os.path.expanduser("~/soda/05-LOGS/")
    anomalías = []
    for root, dirs, files in os.walk(log_dir):
        for f in files:
            path = os.path.join(root, f)
            with open(path, "r", errors="ignore") as log:
                contenido = log.read().lower()
                if "error" in contenido:
                    anomalías.append(f"Error detectado en log: {path}")
                if "exception" in contenido:
                    anomalías.append(f"Excepción detectada en log: {path}")
    return anomalías

def diagnostico_completo():
    return {
        "timestamp": time.time(),
        "resumen": "Diagnóstico general del sistema.",
        "carpetas": analizar_carpetas(),
        "procesos": analizar_procesos(),
        "logs": analizar_logs(),
        "recomendaciones": [
            "Revisar carpetas con acumulación.",
            "Verificar procesos Python activos.",
            "Revisar logs con errores o excepciones."
        ]
    }
