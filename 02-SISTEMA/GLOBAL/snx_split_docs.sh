#!/data/data/com.termux/files/usr/bin/bash

FILE="$HOME/soda/TODO_EL_SISTEMA.txt"
OUTDIR="$HOME/soda/TODO_SPLIT"
mkdir -p "$OUTDIR"

split -l 10000 "$FILE" "$OUTDIR/parte_"

echo "Partes generadas en: $OUTDIR"
