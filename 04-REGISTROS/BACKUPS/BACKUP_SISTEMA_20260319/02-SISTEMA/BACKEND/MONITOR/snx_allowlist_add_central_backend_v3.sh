#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — FASE 5.9.8
# Añadir entrada "central_backend_v3" a allowed_scripts.json sin modificar nada.
# ============================================================================

DIR="$HOME/soda/02-SISTEMA/BACKEND/MONITOR"
ALLOW="$DIR/allowed_scripts.json"
BACKUP="$DIR/allowed_scripts.json.bak_v3_$(date +%Y%m%d-%H%M%S)"
TEMP="$DIR/allowed_scripts.new.v3.json"

cp "$ALLOW" "$BACKUP"

jq '.allowed.central_backend_v3 = "02-SCRIPTS/GLOBAL/snx_central_backend_v3.sh"' "$ALLOW" > "$TEMP"

mv "$TEMP" "$ALLOW"

echo "[SNX] allowlist actualizada con central_backend_v3."
echo "[SNX] FASE 5.9.8 COMPLETADA."
# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL — SNX‑2026‑B
# ============================================================================
