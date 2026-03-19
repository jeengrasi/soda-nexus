#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — WATCHDOG DE ARCHIVOS SAGRADOS V1
# Verifica integridad cada 30 segundos.
# ============================================================================

SODA="$HOME/soda"

while true; do
    "$SODA/02-SCRIPTS/ANTIAMNESIA/snx_verificar_archivos_sagrados_v1.sh" >/dev/null 2>&1
    sleep 30
done

# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL — SNX‑2026‑B
# ============================================================================
