#!/data/data/com.termux/files/usr/bin/bash

BASE="$HOME/soda"
OUT="$BASE/01-MEMORIA/ACTUAL/sondeo_vaults_sistema.txt"

echo "SONDEO DE VAULTS Y SECRETOS — SODA-NEXUS" > "$OUT"
echo "Fecha: $(date -u +"%Y-%m-%d %H:%M:%S UTC")" >> "$OUT"
echo >> "$OUT"

echo "Carpetas llamadas VAULT:" >> "$OUT"
find "$BASE" -type d -iname "vault" >> "$OUT"

echo >> "$OUT"
echo "Archivos que contienen la palabra KEY:" >> "$OUT"
grep -RIl --exclude-dir=".git" "KEY" "$BASE" >> "$OUT" 2>/dev/null || true

echo >> "$OUT"
echo "FIN DEL SONDEO" >> "$OUT"
