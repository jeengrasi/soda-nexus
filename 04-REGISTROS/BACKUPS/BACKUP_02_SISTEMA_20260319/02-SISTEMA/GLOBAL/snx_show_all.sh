#!/data/data/com.termux/files/usr/bin/bash

FILE="$HOME/soda/TODO_EL_SISTEMA.txt"

if [ ! -f "$FILE" ]; then
  echo "ERROR: El archivo TODO_EL_SISTEMA.txt no existe."
  exit 1
fi

echo "=== MOSTRANDO TODO_EL_SISTEMA.txt ==="
echo "Usa las flechas o desliza para navegar. Presiona q para salir."
echo ""

less -R "$FILE"

echo ""
echo "=== FIN ==="
