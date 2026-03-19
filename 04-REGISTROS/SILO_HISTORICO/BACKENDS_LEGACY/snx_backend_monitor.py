#!/data/data/com.termux/files/usr/bin/python
# ============================================================================
# SNX-BACKEND-MONITOR — SODA-NEXUS
# Backend soberano del Monitor Soberano.
# No ejecuta scripts. No modifica el sistema.
# Solo expone rutas seguras para lectura y propuestas.
# ============================================================================

from fastapi import FastAPI
from fastapi.responses import JSONResponse
import os, json

SODA = os.path.expanduser("~/soda")
REGISTROS = f"{SODA}/05-REGISTROS"
GUARDIAN_ALERTAS = f"{REGISTROS}/GUARDIAN/ALERTAS"
GUARDIAN_SESIONES = f"{REGISTROS}/GUARDIAN/SESIONES"

app = FastAPI(title="SNX Backend Monitor")

def listar_directorio(ruta):
    try:
        contenido = os.listdir(ruta)
        return {"ruta": ruta, "contenido": contenido}
    except Exception as e:
        return {"error": str(e)}

@app.get("/listar")
def listar(ruta: str):
    return listar_directorio(ruta)

@app.get("/leer")
def leer_archivo(ruta: str):
    try:
        with open(ruta, "r") as f:
            return {"ruta": ruta, "contenido": f.read()}
    except Exception as e:
        return {"error": str(e)}

@app.get("/guardian/alertas")
def alertas_guardian():
    try:
        archivos = os.listdir(GUARDIAN_ALERTAS)
        return {"alertas": archivos}
    except:
        return {"alertas": []}

@app.get("/guardian/sesiones")
def sesiones_guardian():
    try:
        archivos = os.listdir(GUARDIAN_SESIONES)
        return {"sesiones": archivos}
    except:
        return {"sesiones": []}

@app.post("/proponer")
def proponer(data: dict):
    ruta = f"{REGISTROS}/propuestas.json"
    try:
        with open(ruta, "a") as f:
            f.write(json.dumps(data) + "\n")
        return {"estado": "registrado"}
    except Exception as e:
        return {"error": str(e)}

# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL
# Este backend forma parte del circuito soberano Monitor → Termux.
# No ejecuta acciones. Solo expone información y registra propuestas.
# ============================================================================
