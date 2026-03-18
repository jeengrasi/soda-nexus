#!/data/data/com.termux/files/usr/bin/bash
set -e

BASE="$HOME/soda"
MEMORIA_ACTUAL="$BASE/01-MEMORIA/ACTUAL"
HASH_DIR="$MEMORIA_ACTUAL/HASHES"
LOG_DIR="$BASE/04-REGISTROS/SYSTEM"
ESTADO_DIR="$BASE/00-GOBIERNO/ESTADO"
ESTADO_GLOBAL="$ESTADO_DIR/snx_state.json"

mkdir -p "$LOG_DIR" "$ESTADO_DIR"

LOG_FILE="$LOG_DIR/antiamnesia_soberano.log"

log() {
  printf "[%s] [ANTIAMNESIA] %s\n" "$(date +'%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE"
}

# -------------------------
# 1. Verificación de hashes
# -------------------------
check_hashes() {
  log "INICIO: verificación de integridad por HASHES existentes"

  # Mapeo explícito: archivo de hash -> ruta de script
  while IFS= read -r hf; do
    hbase="$(basename "$hf")"
    case "$hbase" in
      00_GOBIERNO_snx_ia_gobierno.sh.sha)
        target="$BASE/00-GOBIERNO/snx_ia_gobierno.sh"
        ;;
      01_MEMORIA_snx_ia_memoria.sh.sha)
        target="$BASE/01-MEMORIA/snx_ia_memoria.sh"
        ;;
      02_SISTEMA_snx_ia_sistema.sh.sha)
        target="$BASE/02-SISTEMA/snx_ia_sistema.sh"
        ;;
      02_SISTEMA_GLOBAL_snx_ia_central.sh.sha)
        target="$BASE/02-SISTEMA/GLOBAL/snx_ia_central.sh"
        ;;
      03_OPERACIONES_snx_ia_operaciones.sh.sha)
        target="$BASE/03-OPERACIONES/snx_ia_operaciones.sh"
        ;;
      04_REGISTROS_snx_ia_registros.sh.sha)
        target="$BASE/04-REGISTROS/snx_ia_registros.sh"
        ;;
      05_DOCUMENTACION_snx_ia_documentacion.sh.sha)
        target="$BASE/05-DOCUMENTACION/snx_ia_documentacion.sh"
        ;;
      06_MONITOR_snx_ia_monitor.sh.sha)
        target="$BASE/06-MONITOR/snx_ia_monitor.sh"
        ;;
      *)
        log "AVISO: hash desconocido (sin mapeo): $hbase"
        continue
        ;;
    esac

    if [ ! -f "$target" ]; then
      log "ALERTA: archivo objetivo desaparecido: $target (hash: $hbase)"
      continue
    fi

    hash_prev="$(cat "$hf" 2>/dev/null || echo "")"
    if [ -z "$hash_prev" ]; then
      log "ALERTA: hash vacío o ilegible: $hbase"
      continue
    fi

    hash_actual="$(sha256sum "$target" | awk '{print $1}')"

    if [ "$hash_actual" != "$hash_prev" ]; then
      log "ALERTA: INTEGRIDAD VIOLADA: $target"
      log "        HASH previo:  $hash_prev"
      log "        HASH actual: $hash_actual"
    else
      log "OK HASH: $target"
    fi
  done < <(find "$HASH_DIR" -maxdepth 1 -type f -name '*.sha' | sort)

  log "FIN: verificación de integridad por HASHES existentes"
}

# -----------------------------------
# 2. Revisión de MEMORIA por ministerio
# -----------------------------------
check_memoria_ministerios() {
  log "INICIO: revisión de MEMORIA/ACTUAL por ministerio"

  for cod in 00-GOBIERNO 01-MEMORIA 02-SISTEMA 03-OPERACIONES 04-REGISTROS 05-DOCUMENTACION 06-MONITOR; do
    base_cod="${cod}"
    cod_simple="${cod%%-*}"   # 00, 01, 02...
    log "MINISTERIO: $cod"

    estado="$MEMORIA_ACTUAL/estado_${cod}.json"
    engranaje="$MEMORIA_ACTUAL/engranaje_${cod}.json"
    sync="$MEMORIA_ACTUAL/sync_${cod}.json"

    [ -f "$estado" ]    && log "  OK estado:    $(basename "$estado")"    || log "  FALTA estado:    estado_${cod}.json"
    [ -f "$engranaje" ] && log "  OK engranaje: $(basename "$engranaje")" || log "  FALTA engranaje: engranaje_${cod}.json"
    [ -f "$sync" ]      && log "  OK sync:      $(basename "$sync")"      || log "  FALTA sync:      sync_${cod}.json"
  done

  log "FIN: revisión de MEMORIA/ACTUAL por ministerio"
}

# -----------------------------------
# 3. Versionado del estado global
# -----------------------------------
versionar_estado_global() {
  log "INICIO: versionado de estado global"

  if [ ! -f "$ESTADO_GLOBAL" ]; then
    log "AVISO: no existe estado global en $ESTADO_GLOBAL, no se versiona"
    return 0
  fi

  ts="$(date +'%Y%m%d-%H%M%S')"
  backup="$ESTADO_DIR/snx_state_${ts}.json"

  cp "$ESTADO_GLOBAL" "$backup"
  log "Estado global versionado: $(basename "$backup")"

  log "FIN: versionado de estado global"
}

# -----------------------------------
# 4. Snapshot antiamnesia (texto)
# -----------------------------------
snapshot_antiamnesia() {
  SNAP_FILE="$MEMORIA_ACTUAL/antiamnesia_snapshot.txt"
  log "Generando snapshot antiamnesia en $SNAP_FILE"

  {
    echo "SNX-ANTIAMNESIA-SOBERANO-V3"
    echo "Fecha: $(date +'%Y-%m-%d %H:%M:%S')"
    echo
    echo "== HASHES EXISTENTES =="
    ls -1 "$HASH_DIR" 2>/dev/null || echo "(sin HASHES)"

    echo
    echo "== ESTADOS POR MINISTERIO =="
    ls -1 "$MEMORIA_ACTUAL"/estado_*.json 2>/dev/null || echo "(sin estados)"

    echo
    echo "== ENGRANAJES POR MINISTERIO =="
    ls -1 "$MEMORIA_ACTUAL"/engranaje_*.json 2>/dev/null || echo "(sin engranajes)"

    echo
    echo "== SYNC POR MINISTERIO =="
    ls -1 "$MEMORIA_ACTUAL"/sync_*.json 2>/dev/null || echo "(sin sync)"

    echo
    echo "== ARCHIVOS RELACIONADOS CON MONITOR =="
    ls -1 "$MEMORIA_ACTUAL"/monitor_* 2>/dev/null || echo "(sin monitor_*)"

    echo
    echo "== SNAPSHOTS DE ARBOLES =="
    ls -1 "$MEMORIA_ACTUAL"/*tree* 2>/dev/null || echo "(sin *tree*)"

    echo
    echo "== TODO_EL_SISTEMA_snapshot =="
    ls -1 "$MEMORIA_ACTUAL"/TODO_EL_SISTEMA_snapshot.txt 2>/dev/null || echo "(no existe TODO_EL_SISTEMA_snapshot.txt)"
  } > "$SNAP_FILE"

  log "Snapshot antiamnesia actualizado: $SNAP_FILE"
}

# -----------------------------------
# 5. Modo principal
# -----------------------------------
main() {
  log "INICIO EJECUCION SNX-ANTIAMNESIA-SOBERANO-V3"

  check_hashes
  check_memoria_ministerios
  versionar_estado_global
  snapshot_antiamnesia

  log "FIN EJECUCION SNX-ANTIAMNESIA-SOBERANO-V3"
}

main "$@"
