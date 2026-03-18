#!/data/data/com.termux/files/usr/bin/bash
set -e

MINISTERIO="05-DOCUMENTACION"
BASE="$HOME/soda/$MINISTERIO"
MEM="$HOME/soda/01-MEMORIA/ACTUAL"
CTX="$HOME/soda/05-DOCUMENTACION/CONTEXTOS"
LOG="$HOME/soda/04-REGISTROS/SYSTEM"

mkdir -p "$MEM" "$CTX" "$LOG"

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] [$MINISTERIO] $1" | tee -a "$LOG/${MINISTERIO}_ia.log"
}

mod_memoria() {
  ls -1 "$BASE" > "$MEM/docs_index_${MINISTERIO}.txt" 2>/dev/null || true
}

mod_contexto() {
  FILE="$CTX/CTX-${MINISTERIO}.md"
  if [ ! -f "$FILE" ]; then
    echo "# Contexto $MINISTERIO" > "$FILE"
    echo "- Documentación institucional del sistema" >> "$FILE"
  fi
}

mod_antiamnesia() {
  if [ ! -d "$BASE" ]; then
    log "ALERTA: falta carpeta de documentación"
  fi
}

mod_auditoria() {
  du -sh "$BASE" > "$LOG/${MINISTERIO}_du.log" 2>/dev/null || true
}

mod_engranaje() {
  echo "{\"relaciones\":[\"01-MEMORIA\",\"06-MONITOR\"]}" > "$MEM/engranaje_${MINISTERIO}.json"
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
    echo "  \"docs_index\": \"$( [ -f "$MEM/docs_index_${MINISTERIO}.txt" ] && wc -l < "$MEM/docs_index_${MINISTERIO}.txt" || echo 0 ) entradas\","
    echo "  \"engranaje\": $(cat "$MEM/engranaje_${MINISTERIO}.json"),"
    echo "  \"sync\": $(cat "$MEM/sync_${MINISTERIO}.json"),"
    echo "  \"archivos\": {"
    echo "    \"docs_index\": \"$( [ -f "$MEM/docs_index_${MINISTERIO}.txt" ] && echo ok || echo missing )\","
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
