#!/data/data/com.termux/files/usr/bin/bash
set -e

MINISTERIO="00-GOBIERNO"
BASE="$HOME/soda/$MINISTERIO"
MEM="$HOME/soda/01-MEMORIA/ACTUAL"
CTX="$HOME/soda/05-DOCUMENTACION/CONTEXTOS"
LOG="$HOME/soda/04-REGISTROS/SYSTEM"

mkdir -p "$MEM" "$CTX" "$LOG"

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$MINISTERIO] $1" | tee -a "$LOG/${MINISTERIO}_ia.log"
}

mod_memoria() {
  echo "{\"ministerio\":\"$MINISTERIO\",\"timestamp\":\"$(date +'%Y-%m-%dT%H:%M:%S')\"}" > "$MEM/estado_${MINISTERIO}.json"
}

mod_contexto() {
  FILE="$CTX/CTX-${MINISTERIO}.md"
  if [ ! -f "$FILE" ]; then
    echo "# Contexto $MINISTERIO" > "$FILE"
    echo "- Gobierno central" >> "$FILE"
  fi
}

mod_antiamnesia() {
  if [ ! -d "$BASE" ]; then
    log "ALERTA: carpeta del ministerio no existe"
  fi
}

mod_auditoria() {
  ls -1 "$BASE" > "$LOG/${MINISTERIO}_estructura.log" 2>/dev/null || true
}

mod_engranaje() {
  echo "{\"relaciones\":[\"01-MEMORIA\",\"02-SISTEMA\"]}" > "$MEM/engranaje_${MINISTERIO}.json"
}

mod_sinc() {
  echo "{\"sync\":\"$(date +'%Y-%m-%dT%H:%M:%S')\"}" > "$MEM/sync_${MINISTERIO}.json"
}

main() {
  log "INICIO"
  mod_memoria
  mod_contexto
  mod_antiamnesia
  mod_auditoria
  mod_engranaje
  mod_sinc
  log "FIN"
}

main
