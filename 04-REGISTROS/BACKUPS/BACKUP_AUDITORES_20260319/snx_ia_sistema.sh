#!/data/data/com.termux/files/usr/bin/bash
set -e

MINISTERIO="02-SISTEMA"
BASE="$HOME/soda/$MINISTERIO"
MEM="$HOME/soda/01-MEMORIA/ACTUAL"
CTX="$HOME/soda/05-DOCUMENTACION/CONTEXTOS"
LOG="$HOME/soda/04-REGISTROS/SYSTEM"

mkdir -p "$MEM" "$CTX" "$LOG"

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$MINISTERIO] $1" | tee -a "$LOG/${MINISTERIO}_ia.log"
}

mod_memoria() {
  find "$BASE" -maxdepth 3 -type f -name "snx_*" > "$MEM/inventario_${MINISTERIO}.txt" 2>/dev/null || true
}

mod_contexto() {
  FILE="$CTX/CTX-${MINISTERIO}.md"
  if [ ! -f "$FILE" ]; then
    echo "# Contexto $MINISTERIO" > "$FILE"
    echo "- Motor del sistema" >> "$FILE"
  fi
}

mod_antiamnesia() {
  if [ ! -d "$BASE" ]; then
    log "ALERTA: falta carpeta del sistema"
  fi
}

mod_auditoria() {
  for f in $(find "$BASE" -maxdepth 3 -type f -name "snx_*"); do
    if [ ! -x "$f" ]; then
      log "AVISO: $f sin permiso de ejecución"
    fi
  done
}

mod_engranaje() {
  echo "{\"relaciones\":[\"03-OPERACIONES\",\"04-REGISTROS\"]}" > "$MEM/engranaje_${MINISTERIO}.json"
}

mod_sinc() {
  echo "{\"sync\":\"$(date +'%Y-%m-%dT%H:%M:%S')\"}" > "$MEM/sync_${MINISTERIO}.json"
}

mod_estado() {
  ESTADO="$MEM/estado_${MINISTERIO}.json"

  {
    echo "{"
    echo "  \"ministerio\": \"$MINISTERIO\","
    echo "  \"timestamp\": \"$(date +'%Y-%m-%dT%H:%M:%S')\","
    echo "  \"inventario\": \"$( [ -f "$MEM/inventario_${MINISTERIO}.txt" ] && wc -l < "$MEM/inventario_${MINISTERIO}.txt" || echo 0 ) archivos\","
    echo "  \"engranaje\": $(cat "$MEM/engranaje_${MINISTERIO}.json"),"
    echo "  \"sync\": $(cat "$MEM/sync_${MINISTERIO}.json"),"
    echo "  \"archivos\": {"
    echo "    \"inventario\": \"$( [ -f "$MEM/inventario_${MINISTERIO}.txt" ] && echo ok || echo missing )\","
    echo "    \"engranaje\": \"$( [ -f "$MEM/engranaje_${MINISTERIO}.json" ] && echo ok || echo missing )\","
    echo "    \"sync\": \"$( [ -f "$MEM/sync_${MINISTERIO}.json" ] && echo ok || echo missing )\""
    echo "  }"
    echo "}"
  } > "$ESTADO"

  log "Estado generado: $(basename "$ESTADO")"
}

main() {
  log "INICIO"
  mod_memoria
  mod_contexto
  mod_antiamnesia
  mod_auditoria
  mod_engranaje
  mod_sinc
  mod_estado
  log "FIN"
}

main
