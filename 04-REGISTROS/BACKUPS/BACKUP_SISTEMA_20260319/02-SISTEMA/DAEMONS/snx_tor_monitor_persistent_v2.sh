#!/data/data/com.termux/files/usr/bin/bash

TORRC_MONITOR="$HOME/soda/02-SISTEMA/TOR/torrc_snx_monitor_v2"
HS_MONITOR_DIR="$HOME/.tor/snx_monitor_service_v2"
LOG_FILE="$HOME/soda/05-LOGS/TUNNEL/tor_snx_monitor_v2.log"

mkdir -p "$(dirname "$LOG_FILE")"

start_tor() {
  tor -f "$TORRC_MONITOR" >> "$HOME/soda/05-LOGS/TUNNEL/tor_snx_monitor_v2_runtime.log" 2>&1 &
}

get_onion() {
  if [ -f "$HS_MONITOR_DIR/hostname" ]; then
    cat "$HS_MONITOR_DIR/hostname"
  else
    echo ""
  fi
}

main() {
  start_tor
  sleep 10
  ONION=$(get_onion)
  echo "$ONION" > "$HOME/soda/00-VAULT/SNX-TOR-MONITOR-V2.txt"
}

main
