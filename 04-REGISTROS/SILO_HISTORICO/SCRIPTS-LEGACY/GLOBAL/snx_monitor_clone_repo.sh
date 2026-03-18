#!/usr/bin/env bash
set -e

echo "=== SODA-NEXUS :: CLONAR / ACTUALIZAR REPO DEL MONITOR ==="

read -p "URL del repositorio Git (ej: https://github.com/jeengras1/finanzas-brillantes.git): " REPO_URL
read -p "Ruta local destino (ej: /data/data/com.termux/files/home/soda/REPOS/finanzas-brillantes): " REPO_DIR

if [ -z "$REPO_URL" ] || [ -z "$REPO_DIR" ]; then
  echo "URL o ruta vacía. Abortando."
  exit 1
fi

if [ -d "$REPO_DIR/.git" ]; then
  echo "Repositorio ya existe en $REPO_DIR, haciendo git pull..."
  cd "$REPO_DIR"
  git pull
else
  echo "Clonando repositorio en $REPO_DIR..."
  mkdir -p "$(dirname "$REPO_DIR")"
  cd "$(dirname "$REPO_DIR")"
  git clone "$REPO_URL" "$(basename "$REPO_DIR")"
fi

echo "=== OK: Repositorio listo en $REPO_DIR ==="
