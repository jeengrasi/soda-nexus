#!/data/data/com.termux/files/usr/bin/bash
set -e

BASE_SODA="$HOME/soda"
REG_SYSTEM_DIR="$BASE_SODA/04-REGISTROS/SYSTEM"
ESTADO_GLOBAL="$BASE_SODA/00-GOBIERNO/ESTADO/snx_state.json"
MEMORIA_DIR="$BASE_SODA/01-MEMORIA/ACTUAL"

mkdir -p "$REG_SYSTEM_DIR" "$MEMORIA_DIR"

log() {
  printf "[%s] [CENTRAL] %s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$REG_SYSTEM_DIR/central_ia.log"
}

run_ministerio() {
  local nombre="$1"
  local script="$2"

  if [ -x "$script" ]; then
    log "EJECUTANDO IA ministerial: $nombre -> $script"
    if "$script"; then
      log "OK IA ministerial: $nombre"
    else
      log "ERROR IA ministerial: $nombre (falló ejecución)"
    fi
  else
    log "AVISO: script IA ministerial no encontrado o no ejecutable: $script"
  fi
}

consolidar_estados() {
  log "CONSOLIDACION: construyendo estado global desde 01-MEMORIA/ACTUAL"

  tmp_file="$(mktemp)"

  # Encabezado JSON
  echo "{\"sistema\":{\"timestamp\":\"$(date +'%Y-%m-%dT%H:%M:%S')\",\"ministerios\":{" > "$tmp_file"

  first=1
  for estado in "$MEMORIA_DIR"/estado_*.json; do
    [ -f "$estado" ] || continue

    ministerio=$(basename "$estado" | sed 's/^estado_//; s/\.json$//')
    contenido=$(cat "$estado")

    if [ $first -eq 0 ]; then
      echo "," >> "$tmp_file"
    fi
    first=0

    echo "\"$ministerio\": $contenido" >> "$tmp_file"
  done

  # Cierre JSON
  echo "}}}" >> "$tmp_file"

  mv "$tmp_file" "$ESTADO_GLOBAL"
  log "CONSOLIDACION: estado global actualizado en $ESTADO_GLOBAL"
}

antiamnesia_global() {
  log "ANTIAMNESIA GLOBAL: verificando que existan ministerios base"

  for d in 00-GOBIERNO 01-MEMORIA 02-SISTEMA 03-OPERACIONES 04-REGISTROS 05-DOCUMENTACION 06-MONITOR; do
    if [ ! -d "$BASE_SODA/$d" ]; then
      log "ALERTA ANTIAMNESIA GLOBAL: falta ministerio $d"
    fi
  done
}

reporte_global() {
  log "REPORTE GLOBAL: generando snapshot de estructura"
  if [ -x "$BASE_SODA/02-SISTEMA/GLOBAL/snx_system_map.sh" ]; then
    "$BASE_SODA/02-SISTEMA/GLOBAL/snx_system_map.sh" > "$REG_SYSTEM_DIR/system_map_$(date +%Y%m%d_%H%M%S).log" 2>/dev/null || true
  else
    log "AVISO: snx_system_map.sh no existe o no es ejecutable"
  fi
}

main() {
  log "INICIO CICLO IA-SCRIPT CENTRAL"

  run_ministerio "00-GOBIERNO"      "$BASE_SODA/00-GOBIERNO/snx_ia_gobierno.sh"
  run_ministerio "01-MEMORIA"       "$BASE_SODA/01-MEMORIA/snx_ia_memoria.sh"
  run_ministerio "02-SISTEMA"       "$BASE_SODA/02-SISTEMA/snx_ia_sistema.sh"
  run_ministerio "03-OPERACIONES"   "$BASE_SODA/03-OPERACIONES/snx_ia_operaciones.sh"
  run_ministerio "04-REGISTROS"     "$BASE_SODA/04-REGISTROS/snx_ia_registros.sh"
  run_ministerio "05-DOCUMENTACION" "$BASE_SODA/05-DOCUMENTACION/snx_ia_documentacion.sh"
  run_ministerio "06-MONITOR"       "$BASE_SODA/06-MONITOR/snx_ia_monitor.sh"

  antiamnesia_global
  consolidar_estados
  reporte_global

  log "FIN CICLO IA-SCRIPT CENTRAL"
}

main "$@"
