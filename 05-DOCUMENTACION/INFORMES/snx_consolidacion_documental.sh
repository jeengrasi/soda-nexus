#!/data/data/com.termux/files/usr/bin/bash
set -e

BASE="$HOME/soda"
MEM="$BASE/01-MEMORIA/ACTUAL"
OUT="$BASE/05-DOCUMENTACION/INFORMES"

mkdir -p "$OUT"

DOC="$OUT/INFORME-CONSOLIDACION-DOCUMENTAL.md"

{
  echo "# INFORME DE CONSOLIDACIÓN DOCUMENTAL"
  echo "Fecha: $(date)"
  echo "## Estructura del sistema"
  tree "$BASE" || echo "(tree no disponible)"
  echo "## Estados ministeriales"
  ls -1 "$MEM"/estado_*.json
  echo "## Engranajes"
  ls -1 "$MEM"/engranaje_*.json
  echo "## Sync"
  ls -1 "$MEM"/sync_*.json
  echo "## Anti-Amnesia Soberano"
  ls -1 "$BASE/02-SISTEMA/ANTIAMNESIA"
  echo "## CENTRAL"
  ls -1 "$BASE/02-SISTEMA/GLOBAL"
} > "$DOC"

echo "Documento generado: $DOC"
