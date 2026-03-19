#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# SNX — Mostrar TODO_EL_SISTEMA.txt en pantalla
# PROPOSITO:
#   - Mostrar el contenido completo del archivo generado.
#   - Permitir copiarlo por partes para otra IA.
#   - No modifica nada, solo lectura.
# ============================================================

FILE="$HOME/soda/TODO_EL_SISTEMA.txt"

if [ ! -f "$FILE" ]; then
  echo "ERROR: El archivo TODO_EL_SISTEMA.txt no existe."
  exit 1
fi

echo "=== SNX: MOSTRANDO TODO_EL_SISTEMA.txt ==="
echo ""

# Mostrar el archivo con paginación segura
less "$FILE"

echo ""
echo "=== SNX: FIN DE LECTURA ==="

# ============================================================
# PIE DE PAGINA INSTITUCIONAL
#   - Documento: snx_show_todo.sh
#   - Rol: Visualización total del sistema
#   - Autor: Copilot + Director Jeisson
#   - Antiamnesia: Lectura completa del Estado
# ============================================================
