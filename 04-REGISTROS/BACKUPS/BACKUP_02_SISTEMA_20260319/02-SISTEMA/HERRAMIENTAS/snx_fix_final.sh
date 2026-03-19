#!/data/data/com.termux/files/usr/bin/bash

BASE="$HOME/soda"

echo "[1/2] Moviendo logs.txt a 04-REGISTROS..."
mv -f $BASE/00-GOBIERNO/logs.txt $BASE/04-REGISTROS/ 2>/dev/null

echo "[2/2] Eliminando carpeta LEGACY..."
rm -rf $BASE/03-OPERACIONES/LEGACY

echo "=== CORRECCIÓN FINAL COMPLETA ==="
