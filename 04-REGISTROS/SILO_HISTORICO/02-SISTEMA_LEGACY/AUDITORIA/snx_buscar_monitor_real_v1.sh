#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — BUSCADOR DE MONITOR REAL V1
# Busca SOLO archivos que contengan elementos reales del Monitor Soberano.
# ============================================================================

SODA="$HOME/soda"
OUT="$SODA/01-MEMORIA/ACTUAL/SNX-MONITOR-REAL-ENCONTRADO.md"

{
    echo "# SNX — MONITOR REAL ENCONTRADO"
    echo "## Fecha"
    date
    echo ""

    echo "## Buscando archivos HTML con:"
    echo "- 'Monitor Soberano'"
    echo "- 'Ministerio 0'"
    echo "- 'Desviaciones'"
    echo ""

    echo "### Archivos HTML candidatos"
    echo '```'
    grep -RIl --include="*.html" \
        -e "Monitor Soberano" \
        -e "Ministerio 0" \
        -e "Desviaciones" \
        "$SODA" 2>/dev/null | sed "s|$SODA||"
    echo '```'
    echo ""

    echo "## Buscando archivos JS con:"
    echo "- 'ministerio'"
    echo "- 'fetch'"
    echo "- 'monitor'"
    echo ""

    echo "### Archivos JS candidatos"
    echo '```'
    grep -RIl --include="*.js" \
        -e "ministerio" \
        -e "fetch" \
        -e "monitor" \
        "$SODA" 2>/dev/null | sed "s|$SODA||"
    echo '```'
    echo ""

    echo "## Nota"
    echo "Estos son los archivos que contienen el Monitor REAL. No se listan miles,"
    echo "solo los que tienen contenido auténtico del frontend que viste."
} > "$OUT"

echo "[SNX] Auditoría filtrada generada en: $OUT"

# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL — SNX‑2026‑B
# ============================================================================
