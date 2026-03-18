# SNX — IA-SCRIPT MAESTRO 2026  # OBS: Encabezado institucional del cerebro maestro.

import os                      # OBS: Acceso al filesystem.
import json                    # OBS: Manejo de snx_state.json.
import time                    # OBS: Timestamps para registros.
import requests                # OBS: Comunicación con backend HTTP.

BASE = "/data/data/com.termux/files/home/soda"  # OBS: Ruta soberana.
STATE_FILE = os.path.join(BASE, "02-SISTEMA", "snx_state.json")  # OBS: Archivo de estado institucional.
BACKEND_STATUS_URL = "http://127.0.0.1:5000/status"  # OBS: Endpoint de estado del backend.
BACKEND_FOLDERS_URL = "http://127.0.0.1:5000/folders"  # OBS: Endpoint de clasificación de carpetas.

def cargar_estado():           # OBS: Carga snx_state.json si existe.
    if not os.path.exists(STATE_FILE):  # OBS: Si no existe, devuelve estado vacío.
        return {"historial": [], "ultimo_estado": None}
    with open(STATE_FILE, "r") as f:    # OBS: Abre archivo de estado.
        return json.load(f)             # OBS: Devuelve JSON.

def guardar_estado(estado):    # OBS: Guarda snx_state.json.
    with open(STATE_FILE, "w") as f:    # OBS: Abre archivo para escritura.
        json.dump(estado, f, indent=2)  # OBS: Escribe JSON formateado.

def obtener_backend_status():  # OBS: Consulta estado del backend.
    try:
        r = requests.get(BACKEND_STATUS_URL, timeout=2)  # OBS: Llama a /status.
        return r.json()                                  # OBS: Devuelve JSON.
    except Exception as e:
        return {"status": "inactivo", "error": str(e)}   # OBS: Marca backend caído.

def obtener_folders():         # OBS: Consulta clasificación de carpetas.
    try:
        r = requests.get(BACKEND_FOLDERS_URL, timeout=3)  # OBS: Llama a /folders.
        return r.json()                                   # OBS: Devuelve JSON.
    except Exception as e:
        return {"error": str(e), "carpetas": [], "fantasmas": []}  # OBS: Maneja error.

def evaluar_riesgos(data):     # OBS: Evalúa riesgos institucionales.
    riesgos = {"alto": [], "medio": [], "bajo": []}      # OBS: Estructura de riesgos.
    for item in data.get("carpetas", []):                # OBS: Recorre carpetas.
        if item.get("riesgo") in riesgos:                # OBS: Clasifica por riesgo.
            riesgos[item["riesgo"]].append(item["name"])
    fantasmas = [f["name"] for f in data.get("fantasmas", [])]  # OBS: Lista de fantasmas.
    return riesgos, fantasmas                           # OBS: Devuelve resumen.

def registrar_decision(estado_backend, folders):        # OBS: Registra snapshot en snx_state.json.
    estado = cargar_estado()                            # OBS: Carga estado previo.
    riesgos, fantasmas = evaluar_riesgos(folders)       # OBS: Evalúa riesgos actuales.
    snapshot = {                                        # OBS: Construye registro.
        "timestamp": time.ctime(),
        "backend": estado_backend,
        "riesgos": riesgos,
        "fantasmas": fantasmas
    }
    estado["ultimo_estado"] = snapshot                  # OBS: Actualiza último estado.
    estado["historial"].append(snapshot)                # OBS: Agrega al historial.
    guardar_estado(estado)                              # OBS: Persiste cambios.
    return snapshot                                     # OBS: Devuelve snapshot.

def main():                                             # OBS: Punto de entrada maestro.
    backend_status = obtener_backend_status()           # OBS: Consulta backend.
    folders = obtener_folders()                         # OBS: Consulta clasificación.
    snapshot = registrar_decision(backend_status, folders)  # OBS: Registra estado.
    print("[SNX-MASTER] Estado registrado:")            # OBS: Mensaje de salida.
    print(json.dumps(snapshot, indent=2))               # OBS: Muestra snapshot.

if __name__ == "__main__":                              # OBS: Ejecuta si es script principal.
    main()                                              # OBS: Llama a la función principal.

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
