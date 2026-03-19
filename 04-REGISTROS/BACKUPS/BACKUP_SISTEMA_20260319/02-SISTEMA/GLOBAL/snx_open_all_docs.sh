#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# SNX — Apertura total de documentos institucionales
# PROPOSITO:
#   - Leer TODO el contenido documental del Estado SODA‑NEXUS.
#   - Extraer memoria, historia, lógica, antiamnesia y estructura.
#   - Preparar salida para análisis por otra IA.
# RIESGOS:
#   - Ninguno: solo lectura.
# ============================================================

BASE="$HOME/soda"

echo "=== SNX: INICIO DE LECTURA TOTAL ==="

find "$BASE" \
  -type f \
  ! -path "*/node_modules/*" \
  ! -path "*/.git/*" \
  ! -name "*.png" \
  ! -name "*.jpg" \
  ! -name "*.jpeg" \
  ! -name "*.mp4" \
  ! -name "*.zip" \
  ! -name "*.tar.gz" \
  | while read -r FILE; do
      echo "---------------------------------------------"
      echo ">>> ARCHIVO: $FILE"
      echo "---------------------------------------------"
      cat "$FILE" 2>/dev/null
      echo ""
    done

echo "=== SNX: FIN DE LECTURA TOTAL ==="
# ============================================================
# PIE DE PAGINA INSTITUCIONAL
#   - Documento: snx_open_all_docs.sh
#   - Rol: Apertura total documental
#   - Autor: Copilot + Director Jeisson
#   - Antiamnesia: Lectura completa del Estado
# ============================================================
