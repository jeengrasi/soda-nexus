#!/data/data/com.termux/files/usr/bin/bash
set -e

BASE="$HOME/soda"
HASH_DIR="$BASE/01-MEMORIA/ACTUAL/HASHES"
LOG_DIR="$BASE/04-REGISTROS/SYSTEM"

mkdir -p "$HASH_DIR" "$LOG_DIR"

log() {
  printf "[%s] [INTEGRIDAD] %s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$1" >> "$LOG_DIR/integridad.log"
}

SCRIPTS=(
  "00-GOBIERNO/snx_ia_gobierno.sh"
  "01-MEMORIA/snx_ia_memoria.sh"
  "02-SISTEMA/snx_ia_sistema.sh"
  "03-OPERACIONES/snx_ia_operaciones.sh"
  "04-REGISTROS/snx_ia_registros.sh"
  "05-DOCUMENTACION/snx_ia_documentacion.sh"
  "06-MONITOR/snx_ia_monitor.sh"
  "02-SISTEMA/GLOBAL/snx_ia_central.sh"
)

generar_hashes() {
  log "Generando hashes iniciales"
  for script in "${SCRIPTS[@]}"; do
    file="$BASE/$script"
    hash_file="$HASH_DIR/$(echo "$script" | tr '/-' '__').sha"

    if [ -f "$file" ]; then
      sha256sum "$file" | awk '{print $1}' > "$hash_file"
      log "HASH registrado: $script"
    else
      log "AVISO: archivo no encontrado: $script"
    fi
  done
}

verificar_integridad() {
  log "Verificando integridad de scripts"
  for script in "${SCRIPTS[@]}"; do
    file="$BASE/$script"
    hash_file="$HASH_DIR/$(echo "$script" | tr '/-' '__').sha"

    if [ ! -f "$file" ]; then
      log "ALERTA: archivo desaparecido: $script"
      continue
    fi

    if [ ! -f "$hash_file" ]; then
      log "ALERTA: hash no encontrado para $script"
      continue
    fi

    hash_actual=$(sha256sum "$file" | awk '{print $1}')
    hash_prev=$(cat "$hash_file")

    if [ "$hash_actual" != "$hash_prev" ]; then
      log "ALERTA: INTEGRIDAD VIOLADA: $script"
      log "HASH previo:  $hash_prev"
      log "HASH actual: $hash_actual"
    fi
  done
}

case "$1" in
  init)
    generar_hashes
    ;;
  check)
    verificar_integridad
    ;;
  *)
    echo "Uso: $0 {init|check}"
    exit 1
    ;;
esac
