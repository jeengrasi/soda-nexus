#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — ALLOWLIST SOBERANA V2 (FASE 4.6)
# Genera allowed_scripts.json completo, con backup y validación segura en Python.
# ============================================================================

ALLOWLIST_DIR="$HOME/soda/02-SISTEMA/BACKEND/MONITOR"
ALLOWLIST_FILE="$ALLOWLIST_DIR/allowed_scripts.json"
ALLOWLIST_BAK="$ALLOWLIST_DIR/allowed_scripts.json.bak.$(date +%Y%m%d-%H%M%S)"
ALLOWLIST_TMP="$ALLOWLIST_DIR/allowed_scripts_v2.json"

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

echo "[SNX] Validando rutas reales con Python..."

python << 'EOF_PY'
import json, os, sys

base = os.path.expanduser("~/soda")
tmp = os.path.expanduser("~/soda/02-SISTEMA/BACKEND/MONITOR/allowed_scripts_v2.json")

with open(tmp, "r") as f:
    data = json.load(f)

for key, rel_path in data["allowed"].items():
    full = os.path.join(base, rel_path)
    if not os.path.isfile(full):
        print(f"[ERROR] Ruta no encontrada: {full}")
        sys.exit(1)

print("[SNX] Validación completada: todas las rutas existen.")
EOF_PY

if [ $? -ne 0 ]; then
  echo "[SNX] Abortando actualización para evitar corrupción."
  exit 1
fi

echo "[SNX] Creando backup del archivo anterior..."

if [ -f "$ALLOWLIST_FILE" ]; then
  mv "$ALLOWLIST_FILE" "$ALLOWLIST_BAK"
  echo "[SNX] Backup creado: $ALLOWLIST_BAK"
fi

mv "$ALLOWLIST_TMP" "$ALLOWLIST_FILE"
echo "[SNX] Allowlist soberana activada: $ALLOWLIST_FILE"

echo "[SNX] FASE 4.6 — ALLOWLIST COMPLETADA."
# ============================================================================
# SNX — PIE DE PÁGINA INSTITUCIONAL (SCRIPT)
# FASE: 4.6 — Allowlist Soberana (Validador corregido)
# Prohibido modificar a mano; solo mediante fases y scripts aprobados.
# Antes de cualquier cambio, SIEMPRE inspeccionar el filesystem real.
# ============================================================================
