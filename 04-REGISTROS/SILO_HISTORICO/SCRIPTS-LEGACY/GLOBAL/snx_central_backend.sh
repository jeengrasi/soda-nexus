#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# IA-SCRIPT CENTRAL — MODO BACKEND (NO INTERACTIVO)
# SODA-NEXUS — Uso exclusivo del backend soberano V3.
# No pide input, no muestra menús, no bloquea.
# ============================================================================

SODA="$HOME/soda"
REGISTROS="$SODA/05-REGISTROS/GUARDIAN/SESIONES"
MONITOR_DATA="$SODA/06-MONITOR/V3/monitor_data.json"
BACKEND="$SODA/02-SISTEMA/BACKEND"

mkdir -p "$REGISTROS"

timestamp() { date +"%Y-%m-%d %H:%M:%S"; }

registrar() {
    local mensaje="$1"
    local archivo="$REGISTROS/snx_backend_$(date +"%Y%m%d_%H%M%S").log"
    echo "[$(timestamp)] $mensaje" >> "$archivo"
}

registrar "MODO BACKEND: Generando monitor_data.json (no interactivo)."

if [ -f "$BACKEND/monitor_soberano.py" ]; then
    python3 "$BACKEND/monitor_soberano.py" > "$MONITOR_DATA" 2>/tmp/snx_central_backend.err
    CODE=$?
else
    echo "monitor_soberano.py no encontrado en $BACKEND"
    registrar "ERROR: monitor_soberano.py no encontrado."
    exit 1
fi

if [ $CODE -ne 0 ]; then
    echo "ERROR al generar monitor_data.json (código $CODE)."
    registrar "ERROR al generar monitor_data.json (código $CODE)."
    exit $CODE
fi

echo "monitor_data.json generado correctamente en: $MONITOR_DATA"
registrar "monitor_data.json generado correctamente."

echo ""
echo "Estado mínimo del sistema:"
ls -1 "$SODA" || true

# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL
# Script exclusivo para ejecución desde el backend soberano V3.
# No interactivo, no bloqueante, no modifica el sistema sin orden explícita.
# Toda ejecución queda registrada en 05-REGISTROS/GUARDIAN/SESIONES.
# ============================================================================
