#!/data/data/com.termux/files/usr/bin/bash
set -e

BASE="$HOME/soda"
OUT="$BASE/05-DOCUMENTACION/INFORMES"
LOG="$BASE/04-REGISTROS/SYSTEM"

mkdir -p "$OUT" "$LOG"

DOC="$OUT/INFORME-OPTIMIZACION.md"

{
  echo "# INFORME DE OPTIMIZACIÓN"
  echo "Fecha: $(date)"
  echo "## Tamaño de carpetas"
  du -sh "$BASE"/* || true
  echo "## Archivos duplicados"
  find "$BASE" -type f -printf "%f\n" | sort | uniq -d || echo "(ninguno)"
  echo "## Scripts sin permisos"
  find "$BASE" -type f -name "*.sh" ! -perm -111 || echo "(ninguno)"
} > "$DOC"

echo "Optimización completada: $DOC"
