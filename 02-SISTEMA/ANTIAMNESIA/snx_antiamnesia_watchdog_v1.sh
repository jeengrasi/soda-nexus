#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — ANTIAMNESIA WATCHDOG V1
# Ejecutar chequeo periódico y registrar resultado.
# ============================================================================

SODA="$HOME/soda"
SCRIPT="$SODA/02-SCRIPTS/ANTIAMNESIA/snx_memoria_central_v2.sh"

bash "$SCRIPT" resumen >/dev/null 2>&1 || true
bash "$SCRIPT" chequeo >/dev/null 2>&1 || true
bash "$SCRIPT" estado  >/dev/null 2>&1 || true

# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL — SNX‑2026‑B
# ============================================================================
