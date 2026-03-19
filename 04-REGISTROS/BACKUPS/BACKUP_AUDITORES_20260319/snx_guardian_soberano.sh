
#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX GUARDIAN SOBERANO V1
# Sistema de protección, contexto y gobernanza ultra-estricto para SODA-NEXUS
# ============================================================================

SODA_ROOT="$HOME/soda"
GUARDIAN_ROOT="$SODA_ROOT/05-REGISTROS/GUARDIAN"
BASELINE_FILE="$GUARDIAN_ROOT/hashes_baseline.json"
SESSION_LOG_DIR="$GUARDIAN_ROOT/SESIONES"
ALERTS_DIR="$GUARDIAN_ROOT/ALERTAS"

mkdir -p "$GUARDIAN_ROOT" "$SESSION_LOG_DIR" "$ALERTS_DIR"

TIMESTAMP="$(date +"%Y-%m-%d_%H-%M-%S")"
SESSION_LOG="$SESSION_LOG_DIR/snx_guardian_sesion_$TIMESTAMP.log"

CRITICAL_PATHS=(
  "$SODA_ROOT/00-GOBIERNO"
  "$SODA_ROOT/01-ARCHIVO-HISTORICO"
  "$SODA_ROOT/02-SISTEMA"
  "$SODA_ROOT/03-MODULOS"
  "$SODA_ROOT/04-COMUNICACIONES"
  "$SODA_ROOT/05-REGISTROS"
)

log() {
  local msg="$1"
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] $msg" | tee -a "$SESSION_LOG"
}

alerta() {
  local msg="$1"
  local alert_file="$ALERTS_DIR/alerta_$TIMESTAMP.log"
  echo "[$(date +"%Y-%m-%d %H:%M:%S")] ALERTA: $msg" | tee -a "$SESSION_LOG" >> "$alert_file"
}

json_escape() {
  echo "$1" | sed 's/"/\\"/g'
}

clear
echo "==============================================================================="
echo "🛡️  SNX GUARDIAN SOBERANO V1 — MODO OBSERVACIÓN"
echo "==============================================================================="

log "INICIO DE SESIÓN DEL GUARDIAN SOBERANO"

if [ ! -d "$SODA_ROOT" ]; then
  alerta "No se encontró la carpeta raíz SODA-NEXUS en $SODA_ROOT."
  exit 1
fi

log "Estructura base encontrada. Escaneando rutas críticas."

MISSING_PATHS=()
for path in "${CRITICAL_PATHS[@]}"; do
  if [ ! -d "$path" ]; then
    alerta "Ruta crítica ausente: $path"
    MISSING_PATHS+=("$path")
  else
    log "Ruta crítica OK: $path"
  fi
done

TMP_HASHES="$(mktemp)"
echo "{" > "$TMP_HASHES"
FIRST_ENTRY=true

for base in "${CRITICAL_PATHS[@]}"; do
  if [ -d "$base" ]; then
    while IFS= read -r -d '' file; do
      rel_path="${file#$SODA_ROOT/}"
      hash_val="$(sha256sum "$file" | awk '{print $1}')"
      esc_path="$(json_escape "$rel_path")"
      esc_hash="$(json_escape "$hash_val")"
      if [ "$FIRST_ENTRY" = true ]; then
        FIRST_ENTRY=false
      else
        echo "," >> "$TMP_HASHES"
      fi
      echo "  \"${esc_path}\": \"${esc_hash}\"" >> "$TMP_HASHES"
    done < <(find "$base" -type f -print0)
  fi
done

echo "}" >> "$TMP_HASHES"

if [ ! -f "$BASELINE_FILE" ]; then
  cp "$TMP_HASHES" "$BASELINE_FILE"
  log "Baseline inicial creada."
else
  DIFF_FILE="$GUARDIAN_ROOT/diff_$TIMESTAMP.json"
  diff -u "$BASELINE_FILE" "$TMP_HASHES" > "$DIFF_FILE" || true

  if [ -s "$DIFF_FILE" ]; then
    alerta "CAMBIOS DETECTADOS. Archivo diff: $DIFF_FILE"
  else
    log "No se detectaron cambios respecto a la baseline."
  fi
fi

log "FIN DE SESIÓN DEL GUARDIAN SOBERANO."
exit 0
