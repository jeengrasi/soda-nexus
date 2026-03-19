#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — LANZADOR MAESTRO 24/7 V1
# Activa wake‑lock y levanta todos los servicios soberanos del sistema.
# ============================================================================

SODA="$HOME/soda"

echo "[SNX] Iniciando Lanzador Maestro 24/7…"

# ---------------------------------------------------------
# 1. Wake‑lock permanente (si existe)
# ---------------------------------------------------------
if command -v termux-wake-lock >/dev/null 2>&1; then
    termux-wake-lock
    echo "[SNX] Wake‑lock activado."
else
    echo "[SNX] ADVERTENCIA: termux-wake-lock no disponible."
fi

# ---------------------------------------------------------
# 2. Backend monitor (versión existente)
# ---------------------------------------------------------
if [ -x "$SODA/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend_run_v3.sh" ]; then
    "$SODA/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend_run_v3.sh" >/dev/null 2>&1 &
    echo "[SNX] Backend monitor lanzado."
else
    echo "[SNX] ADVERTENCIA: Backend monitor no encontrado."
fi

# ---------------------------------------------------------
# 3. Servidor del Monitor Soberano V1 (ARCHIVO SAGRADO)
# ---------------------------------------------------------
if [ -d "$SODA/03-OPERACIONES/WEB/monitor" ]; then
    cd "$SODA/03-OPERACIONES/WEB/monitor"
    python3 -m http.server 8080 >/dev/null 2>&1 &
    echo "[SNX] Monitor Soberano V1 (sagrado) servido en puerto 8080."
else
    echo "[SNX] ERROR: Carpeta del Monitor Soberano V1 no encontrada."
fi

# ---------------------------------------------------------
# 4. Endpoint antiamnesia (si existe)
# ---------------------------------------------------------
if [ -x "$SODA/02-SISTEMA/BACKEND/MONITOR/snx_antiamnesia_endpoint_v1.py" ]; then
    python3 "$SODA/02-SISTEMA/BACKEND/MONITOR/snx_antiamnesia_endpoint_v1.py" >/dev/null 2>&1 &
    echo "[SNX] Endpoint antiamnesia activo en puerto 5054."
else
    echo "[SNX] ADVERTENCIA: Endpoint antiamnesia no encontrado."
fi

# ---------------------------------------------------------
# 5. Watchdog general (servicios + puertos)
# ---------------------------------------------------------
if [ -x "$SODA/02-SCRIPTS/ANTIAMNESIA/snx_antiamnesia_watchdog_v2.sh" ]; then
    "$SODA/02-SCRIPTS/ANTIAMNESIA/snx_antiamnesia_watchdog_v2.sh" >/dev/null 2>&1 &
    echo "[SNX] Watchdog general activo."
else
    echo "[SNX] ADVERTENCIA: Watchdog general no encontrado."
fi

# ---------------------------------------------------------
# 6. Watchdog de archivos sagrados
# ---------------------------------------------------------
if [ -x "$SODA/02-SCRIPTS/ANTIAMNESIA/snx_watchdog_sagrados_v1.sh" ]; then
    "$SODA/02-SCRIPTS/ANTIAMNESIA/snx_watchdog_sagrados_v1.sh" >/dev/null 2>&1 &
    echo "[SNX] Watchdog de archivos sagrados activo."
else
    echo "[SNX] ADVERTENCIA: Watchdog de archivos sagrados no encontrado."
fi

echo "[SNX] Lanzador Maestro 24/7 completado. Sistema soberano en línea."

# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL — SNX‑2026‑B
# • La memoria es Termux; la IA es desechable.
# • Ningún archivo sagrado puede ser modificado.
# • Toda mejora debe ser versionada, nunca sobrescrita.
# • La integridad del sistema es ley suprema.
# ============================================================================
