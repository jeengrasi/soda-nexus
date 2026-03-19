#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — FASE 3 SERVICES BOOT V1
# Arranque maestro: wake-lock + backend + monitor + antiamnesia + watchdog.
# ============================================================================

SODA="$HOME/soda"

# 1) Wake-lock permanente (si existe termux-wake-lock)
if command -v termux-wake-lock >/dev/null 2>&1; then
    termux-wake-lock
fi

# 2) Backend monitor (no se modifica nada, solo se usa lo existente)
if [ -x "$SODA/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend_run.sh" ]; then
    "$SODA/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend_run_v3.sh" >/dev/null 2>&1 &
fi

# 3) Servidor HTTP del Monitor (V3) en 8080, sin tocar archivos
if [ -d "$SODA/06-MONITOR/V3" ]; then
    cd "$SODA/06-MONITOR/V3"
    python3 -m http.server 8080 >/dev/null 2>&1 &
fi

# 4) Endpoint antiamnesia (si existe)
if [ -x "$SODA/02-SISTEMA/BACKEND/MONITOR/snx_antiamnesia_endpoint_v1.py" ]; then
    python3 "$SODA/02-SISTEMA/BACKEND/MONITOR/snx_antiamnesia_endpoint_v1.py" >/dev/null 2>&1 &
fi

# 5) Watchdog de servicios (Fase 3)
if [ -x "$SODA/02-SCRIPTS/ANTIAMNESIA/snx_antiamnesia_watchdog_v2.sh" ]; then
    "$SODA/02-SCRIPTS/ANTIAMNESIA/snx_antiamnesia_watchdog_v2.sh" >/dev/null 2>&1 &
fi

echo "[SNX] FASE 3 — Servicios 24/7 lanzados (wake-lock + backend + monitor + antiamnesia + watchdog)."

# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL — SNX‑2026‑B
# ============================================================================
