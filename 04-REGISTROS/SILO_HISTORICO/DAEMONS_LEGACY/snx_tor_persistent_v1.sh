#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# snx_tor_persistent_v1.sh
# Daemon soberano para mantener Tor Hidden Service v1 activo
# Versión: 1.0 — Todo nuevo, nada se modifica
# ============================================================

TOR_TORRC="$HOME/soda/02-SISTEMA/TOR/torrc_snx_v1"
HS_DIR="$HOME/.tor/snx_hidden_service_v1"
LOG_FILE="$HOME/soda/05-LOGS/TUNNEL/tor_snx_v1.log"

mkdir -p "$(dirname "$LOG_FILE")"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

wake_lock() {
  if command -v termux-wake-lock >/dev/null 2>&1; then
    termux-wake-lock 2>/dev/null
    log "Wake lock activado"
  else
    log "termux-wake-lock no disponible (instalar termux-api si se requiere)"
  fi
}

get_onion() {
  if [ -f "$HS_DIR/hostname" ]; then
    cat "$HS_DIR/hostname"
  else
    echo ""
  fi
}

start_tor() {
  log "Lanzando Tor con $TOR_TORRC"
  tor -f "$TOR_TORRC" >> "$HOME/soda/05-LOGS/TUNNEL/tor_snx_v1_runtime.log" 2>&1 &
  TOR_PID=$!
  log "Tor iniciado (PID: $TOR_PID)"
}

check_tor() {
  if pgrep -x tor >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

main() {
  log "=== INICIO DAEMON TOR HIDDEN SERVICE V1 ==="
  wake_lock

  if [ ! -f "$TOR_TORRC" ]; then
    log "ERROR: torrc no encontrado en $TOR_TORRC"
    exit 1
  fi

  start_tor
  sleep 10

  ONION=$(get_onion)
  if [ -n "$ONION" ]; then
    log "Hidden Service activo: $ONION"
    echo "$ONION" > "$HOME/soda/00-VAULT/SNX-TOR-ONION-V1.txt"
  else
    log "Aún no se ha generado hostname .onion, se intentará más tarde"
  fi

  while true; do
    if ! check_tor; then
      log "Tor no está corriendo, reiniciando..."
      start_tor
      sleep 10
      ONION=$(get_onion)
      if [ -n "$ONION" ]; then
        log "Hidden Service activo tras reinicio: $ONION"
        echo "$ONION" > "$HOME/soda/00-VAULT/SNX-TOR-ONION-V1.txt"
      fi
    else
      log "Tor Hidden Service v1 operativo"
    fi
    sleep 60
  done
}

trap 'log "Daemon Tor detenido"; exit 0' SIGINT SIGTERM

main

# ============================================================
# PIE INSTITUCIONAL — SODA‑NEXUS
# Daemon Tor soberano. No modificar sin aprobación.
# Garantizar logs, wake lock y preservación de hostname .onion.
# ============================================================
