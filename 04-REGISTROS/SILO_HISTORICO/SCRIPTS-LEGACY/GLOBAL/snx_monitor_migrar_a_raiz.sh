#!/usr/bin/env bash

REPO=$(cat ~/soda/02-SISTEMA/BACKEND/MONITOR/REPO_PATH.txt)

if [ -z "$REPO" ]; then
  echo "ERROR: No se ha seleccionado un repositorio."
  exit 1
fi

echo "Migrando monitor a la raíz de GitHub Pages..."

# Crear carpeta docs si no existe
mkdir -p "$REPO/docs"

# Mover archivos del monitor
cp ~/soda/docs/monitor/index.html "$REPO/docs/index.html"
cp ~/soda/docs/monitor/monitor.js "$REPO/docs/monitor.js"
cp ~/soda/docs/monitor/ia.js "$REPO/docs/ia.js"

cd "$REPO"
git add docs/index.html docs/monitor.js docs/ia.js
git commit -m "Monitor-Termux V3 — Migrado a raíz de GitHub Pages"
echo "Listo para git push."
