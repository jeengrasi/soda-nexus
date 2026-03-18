#!/usr/bin/env bash

REPO=$(cat ~/soda/02-SISTEMA/BACKEND/MONITOR/REPO_PATH.txt 2>/dev/null)

if [ -z "$REPO" ]; then
    echo "ERROR: No se ha seleccionado un repositorio."
    echo "Ejecuta: snx_select_repo.sh"
    exit 1
fi

echo "Publicando monitor en: $REPO/docs/monitor/"
mkdir -p "$REPO/docs/monitor/"

cp ~/soda/docs/monitor/index.html "$REPO/docs/monitor/"
cp ~/soda/docs/monitor/monitor.js "$REPO/docs/monitor/"

cd "$REPO"
git add docs/monitor/index.html docs/monitor/monitor.js
git commit -m "Monitor-Termux V3 - Publicación automática"
echo "Listo para hacer git push."
