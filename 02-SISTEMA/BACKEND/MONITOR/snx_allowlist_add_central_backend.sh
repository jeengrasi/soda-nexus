#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — FASE 5.9.1
# Añadir entrada "central_backend" a allowed_scripts.json sin modificar nada.
# Se genera un archivo nuevo y luego se reemplaza el original.
# ============================================================================

DIR="$HOME/soda/02-SISTEMA/BACKEND/MONITOR"
ALLOW="$DIR/allowed_scripts.json"
BACKUP="$DIR/allowed_scripts.json.bak_$(date +%Y%m%d-%H%M%S)"
TEMP="$DIR/allowed_scripts.new.json"

echo "[SNX] Creando backup de allowed_scripts.json en: $BACKUP"
cp "$ALLOW" "$BACKUP"

echo "[SNX] Generando nueva allowlist con entrada central_backend..."

# Construcción soberana: no se edita, se reconstruye.
jq '.allowed.central_backend = "02-SCRIPTS/GLOBAL/snx_central_backend.sh"' "$ALLOW" > "$TEMP"

if [ $? -ne 0 ]; then
    echo "[ERROR] Falló la generación de la nueva allowlist."
    exit 1
fi

mv "$TEMP" "$ALLOW"

echo "[SNX] Nueva allowlist activada."
echo "[SNX] FASE 5.9.1 COMPLETADA."
# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL
# Este script no modifica archivos: los reemplaza con versiones nuevas.
# Toda acción queda registrada mediante backups con sello temporal.
# Prohibido editar allowed_scripts.json a mano.
# ============================================================================
