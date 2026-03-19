#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# SNX — Árbol completo de carpetas y archivos
# PROPOSITO:
#   - Mostrar TODA la estructura del sistema SODA-NEXUS.
#   - Listar carpetas y archivos con rutas completas.
#   - Compatible con iPad (sin paginación).
# ============================================================

BASE="$HOME/soda"

echo "=== SNX: ESTRUCTURA COMPLETA DEL SISTEMA ==="
echo ""

find "$BASE" -print | sed 's/^/ - /'

echo ""
echo "=== FIN DE ESTRUCTURA ==="

# ============================================================
# PIE DE PAGINA INSTITUCIONAL
#   - Documento: snx_tree.sh
#   - Rol: Mapa completo del sistema
#   - Autor: Copilot + Director Jeisson
#   - Antiamnesia: Estructura total del Estado
# ============================================================
