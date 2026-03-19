#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — AUDITORÍA MONITOR + FRONTEND V1
# No modifica nada. Solo lista TODO lo relacionado con Monitor y frontend.
# ============================================================================

SODA="$HOME/soda"
OUT="$SODA/01-MEMORIA/ACTUAL/SNX-AUDITORIA-MONITOR-FRONTEND.md"

{
    echo "# SNX — AUDITORÍA MONITOR + FRONTEND"
    echo ""
    echo "## Fecha"
    date
    echo ""
    echo "## Rutas inspeccionadas"
    echo "- $SODA/06-MONITOR"
    echo "- $SODA/02-SISTEMA/BACKEND"
    echo "- $SODA/02-SISTEMA/BACKEND/MONITOR"
    echo "- $SODA/docs (si existe)"
    echo ""

    echo "## Contenido de 06-MONITOR (si existe)"
    if [ -d "$SODA/06-MONITOR" ]; then
        echo '```'
        find "$SODA/06-MONITOR" -maxdepth 5 -type f | sed "s|$SODA||"
        echo '```'
    else
        echo "(No existe 06-MONITOR)"
    fi
    echo ""

    echo "## Contenido de BACKEND/MONITOR (si existe)"
    if [ -d "$SODA/02-SISTEMA/BACKEND/MONITOR" ]; then
        echo '```'
        find "$SODA/02-SISTEMA/BACKEND/MONITOR" -maxdepth 5 -type f | sed "s|$SODA||"
        echo '```'
    else
        echo "(No existe 02-SISTEMA/BACKEND/MONITOR)"
    fi
    echo ""

    echo "## Archivos HTML relacionados con Monitor en todo SODA"
    echo '```'
    find "$SODA" -maxdepth 8 -type f -name "*monitor*html" -o -name "*Monitor*html" 2>/dev/null | sed "s|$SODA||"
    echo '```'
    echo ""

    echo "## Archivos JS relacionados con Monitor en todo SODA"
    echo '```'
    find "$SODA" -maxdepth 8 -type f -name "*monitor*js" -o -name "*Monitor*js" 2>/dev/null | sed "s|$SODA||"
    echo '```'
    echo ""

    echo "## Posibles diseños antiguos (por nombre)"
    echo '```'
    find "$SODA" -maxdepth 8 -type f `\( -iname "*soberano*html" -o -iname "*ministerio*html" -o -iname "*monitor*html" \)` 2>/dev/null | sed "s|$SODA||"
    echo '```'
    echo ""

    echo "## Nota"
    echo "Esta auditoría NO modifica nada. Solo existe para que el usuario copie"
    echo "y pegue este archivo en la IA y se pueda reconstruir el Monitor sin"
    echo "inventar rutas ni sobrescribir interfaces previas."
} > "$OUT"

echo "[SNX] Auditoría Monitor + Frontend generada en: $OUT"

# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL — SNX‑2026‑B
# ============================================================================
