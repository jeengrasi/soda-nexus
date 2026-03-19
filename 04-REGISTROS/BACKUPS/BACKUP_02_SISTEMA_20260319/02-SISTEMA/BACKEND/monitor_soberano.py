#!/usr/bin/env python3
import os, json, hashlib

SODA = os.path.expanduser("~/soda")

def sha256(path):
    try:
        h = hashlib.sha256()
        with open(path, "rb") as f:
            for chunk in iter(lambda: f.read(4096), b""):
                h.update(chunk)
        return h.hexdigest()
    except:
        return "ERROR"

def map_system():
    data = {
        "ministerios": { "00": [], "01": [], "02": [], "03": [], "04": [], "05": [] },
        "desviaciones": [],
        "archivos": [],
        "guardian": { "alertas": [], "sesiones": [] }
    }

    guardian_root = os.path.join(SODA, "05-REGISTROS/GUARDIAN")
    if os.path.isdir(guardian_root):
        for sub in ["ALERTAS", "SESIONES"]:
            p = os.path.join(guardian_root, sub)
            if os.path.isdir(p):
                data["guardian"][sub.lower()] = sorted(os.listdir(p))

    for root, dirs, files in os.walk(SODA):
        rel = root.replace(SODA, "")

        if rel.startswith("/00-"): data["ministerios"]["00"].append(rel)
        elif rel.startswith("/01-"): data["ministerios"]["01"].append(rel)
        elif rel.startswith("/02-"): data["ministerios"]["02"].append(rel)
        elif rel.startswith("/03-"): data["ministerios"]["03"].append(rel)
        elif rel.startswith("/04-"): data["ministerios"]["04"].append(rel)
        elif rel.startswith("/05-"): data["ministerios"]["05"].append(rel)
        else:
            if rel != "":
                data["desviaciones"].append(rel)

        for f in files:
            full = os.path.join(root, f)
            try:
                size = os.path.getsize(full)
            except:
                size = "ERROR"

            data["archivos"].append({
                "ruta": full.replace(SODA, ""),
                "tamano": size,
                "hash": sha256(full)
            })

    return data

if __name__ == "__main__":
    print(json.dumps(map_system(), indent=2))
