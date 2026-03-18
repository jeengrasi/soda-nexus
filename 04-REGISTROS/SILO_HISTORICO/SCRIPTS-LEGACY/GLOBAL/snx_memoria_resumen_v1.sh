#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — FASE B
# Generar resumen vivo del sistema para antiamnesia de IA
# ============================================================================

SODA="$HOME/soda"
DEST="$SODA/01-MEMORIA/SNX-RESUMEN-ACTUAL.md"

{
    echo "# SNX — RESUMEN ACTUAL DEL SISTEMA"
    echo ""
    echo "## Fecha"
    date
    echo ""
    echo "## Raíz de SODA"
    echo "\`\`\`"
    ls -1 "$SODA"
    echo "\`\`\`"
    echo ""
    echo "## Monitor y backend"
    echo "- monitor_data.json: $SODA/06-MONITOR/V3/monitor_data.json"
    echo "- backend scripts:   $SODA/02-SCRIPTS/GLOBAL/"
    echo "- backend monitor:   $SODA/02-SISTEMA/BACKEND/MONITOR/"
    echo ""
    echo "## Scripts clave"
    echo "\`\`\`"
    ls -1 "$SODA/02-SCRIPTS/GLOBAL" 2>/dev/null || echo "(sin listar)"
    echo "\`\`\`"
    echo ""
    echo "## Fases registradas en raíz"
    echo "\`\`\`"
    ls -1 "$SODA" | grep 'SNX-FASE' || echo "(sin fases en raíz)"
    echo "\`\`\`"
    echo ""
    echo "## Nota para IA"
    echo "Este archivo existe para que el usuario lo copie y lo pegue en cualquier"
    echo "nueva sesión de IA, permitiendo rehidratar el contexto sin depender de"
    echo "memoria interna del modelo."
} > "$DEST"

echo "[SNX] Resumen actualizado en: $DEST"

# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL — SNX‑2026‑B
# • Siempre se debe ejecutar lo recomendado, seguro y estable para el sistema.
# • Nada se modifica: todo archivo existente se reemplaza mediante scripts soberanos.
# • Prohibido editar archivos a mano.
# • Toda acción debe basarse en evidencia real del filesystem.
# • Este script existe para combatir la amnesia de la IA mediante memoria en Termux.
# ============================================================================
