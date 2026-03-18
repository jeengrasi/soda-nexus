#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — ALLOWLIST SOBERANA V1 (FASE 4.5)
# Genera allowed_scripts.json completo, con backup y validación.
# ============================================================================

ALLOWLIST_DIR="$HOME/soda/02-SISTEMA/BACKEND/MONITOR"
ALLOWLIST_FILE="$ALLOWLIST_DIR/allowed_scripts.json"
ALLOWLIST_BAK="$ALLOWLIST_DIR/allowed_scripts.json.bak.$(date +%Y%m%d-%H%M%S)"
ALLOWLIST_TMP="$ALLOWLIST_DIR/allowed_scripts_v1.json"

echo "[SNX] Generando allowlist soberana en: $ALLOWLIST_TMP"

# ============================================================================
# OBS: Esta allowlist contiene únicamente scripts soberanos de 02-SCRIPTS/GLOBAL.
# OBS: No incluye scripts legacy, backend, servicios ni scripts peligrosos.
# OBS: Todas las rutas son relativas a ~/soda.
# ============================================================================

cat > "$ALLOWLIST_TMP" << 'EOF_JSON'
{
  "allowed": {
    "auditoria_integridad": "02-SCRIPTS/GLOBAL/snx_auditoria_integridad.sh",
    "deploy_estado": "02-SCRIPTS/GLOBAL/snx_deploy_estado.sh",
    "ia_diagnostico": "02-SCRIPTS/GLOBAL/snx_ia_diagnostico.sh",
    "monitor_clone_repo": "02-SCRIPTS/GLOBAL/snx_monitor_clone_repo.sh",
    "monitor_publish_frontend": "02-SCRIPTS/GLOBAL/snx_monitor_publish_frontend.sh",
    "monitor_migrar_a_raiz": "02-SCRIPTS/GLOBAL/snx_monitor_migrar_a_raiz.sh",
    "publish_monitor": "02-SCRIPTS/GLOBAL/snx_publish_monitor.sh",
    "select_repo": "02-SCRIPTS/GLOBAL/snx_select_repo.sh",
    "detect_repos": "02-SCRIPTS/GLOBAL/snx_detect_repos.sh",
    "central": "02-SCRIPTS/GLOBAL/snx_central.sh"
  }
}
EOF_JSON

echo "[SNX] Validando rutas reales..."

BASE="$HOME/soda"

while IFS="=" read -r key value; do
  script_path=$(echo "$value" | tr -d ' ",')
  full="$BASE/$script_path"
  if [ ! -f "$full" ]; then
    echo "[ERROR] Ruta no encontrada: $full"
    echo "[SNX] Abortando actualización para evitar corrupción."
    exit 1
  fi
done < <(grep ":" "$ALLOWLIST_TMP" | grep -v "{")

echo "[SNX] Todas las rutas existen. Procediendo con backup..."

if [ -f "$ALLOWLIST_FILE" ]; then
  mv "$ALLOWLIST_FILE" "$ALLOWLIST_BAK"
  echo "[SNX] Backup creado: $ALLOWLIST_BAK"
fi

mv "$ALLOWLIST_TMP" "$ALLOWLIST_FILE"
echo "[SNX] Allowlist soberana activada: $ALLOWLIST_FILE"

echo "[SNX] FASE 4.5 — ALLOWLIST COMPLETADA."
# ============================================================================
# SNX — PIE DE PÁGINA INSTITUCIONAL (SCRIPT)
# FASE: 4.5 — Allowlist Soberana
# Prohibido modificar a mano; solo mediante fases y scripts aprobados.
# Antes de cualquier cambio, SIEMPRE inspeccionar el filesystem real.
# ============================================================================
