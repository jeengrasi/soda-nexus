#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — VERIFICADOR DE ARCHIVOS SAGRADOS V1
# Verifica integridad, existencia y hash de los archivos sagrados.
# ============================================================================

SODA="$HOME/soda"
SAGRADOS="$SODA/00-GOBIERNO/ARCHIVOS-SAGRADOS.md"
LOG="$SODA/05-REGISTROS/ANTIAMNESIA/sagrados.log"

mkdir -p "$(dirname "$LOG")"

log() {
    local ts
    ts="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$ts] $1" >> "$LOG"
}

# Extraer rutas sagradas del documento institucional
mapfile -t RUTAS < <(grep '^/' "$SAGRADOS" | sed 's/\r//')

errores=0

for ruta in "${RUTAS[@]}"; do
    abs="$SODA$ruta"

    if [ ! -f "$abs" ]; then
        log "ALERTA: Archivo sagrado desaparecido: $abs"
        errores=$((errores+1))
        continue
    fi

    # Hash actual
    hash_actual=$(sha256sum "$abs" | awk '{print $1}')

    # Archivo donde guardamos el hash original
    hash_file="$abs.sha256"

    if [ ! -f "$hash_file" ]; then
        # Primera vez: registrar hash original
        echo "$hash_actual" > "$hash_file"
        log "INFO: Registrado hash inicial para archivo sagrado: $abs"
    else
        hash_prev=$(cat "$hash_file")
        if [ "$hash_actual" != "$hash_prev" ]; then
            log "CRITICO: Archivo sagrado modificado: $abs"
            errores=$((errores+1))
        fi
    fi
done

if [ "$errores" -gt 0 ]; then
    echo "[SNX] ALERTA — Integridad de archivos sagrados comprometida."
    exit 1
else
    echo "[SNX] OK — Archivos sagrados íntegros."
    exit 0
fi

# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL — SNX‑2026‑B
# • La memoria es Termux; la IA es desechable.
# • Ningún archivo sagrado puede ser modificado.
# • Toda mejora debe ser versionada, nunca sobrescrita.
# • La integridad del sistema es ley suprema.
# ============================================================================
