#!/data/data/com.termux/files/usr/bin/bash
# SODA-NEXUS — RESTAURACIÓN DEL MONITOR EN GITHUB V1

set -e

BASE="$HOME/soda"
DOCS="$BASE/docs"

echo "=== Restauración del Monitor en GitHub ==="

# 1. Crear carpeta docs si no existe
mkdir -p "$DOCS"

# 2. Copiar monitor real desde Termux
cp -v "$BASE/docs/index.html" "$DOCS/" 2>/dev/null || true
cp -v "$BASE/04-REGISTROS/monitor_data.json" "$DOCS/" 2>/dev/null || true

# Copiar JS y CSS si existen
find "$BASE" -type f -name "*.js" -not -path "*/.git/*" -exec cp -v {} "$DOCS/" \; 2>/dev/null || true
find "$BASE" -type f -name "*.css" -not -path "*/.git/*" -exec cp -v {} "$DOCS/" \; 2>/dev/null || true

# 3. Commit y push
cd "$BASE"
git add docs
git commit -m "Restauración automática del monitor en GitHub (SODA-NEXUS)"
git push

echo "=== Monitor restaurado en GitHub. Ejecutar Auditor V3 en 30 segundos. ==="
