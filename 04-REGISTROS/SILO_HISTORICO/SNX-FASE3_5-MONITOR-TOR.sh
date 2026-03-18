#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# SODA‑NEXUS — FASE 3.5
# Publicación del Monitor Soberano v2 vía Tor (Hidden Service propio)
# ============================================================

MONITOR_DIR="$HOME/soda/06-MONITOR/V2"
TOR_DIR="$HOME/soda/02-SISTEMA/TOR"
HS_MONITOR_DIR="$HOME/.tor/snx_monitor_service_v2"
TORRC_MONITOR="$TOR_DIR/torrc_snx_monitor_v2"
LOG_TUNNEL="$HOME/soda/05-LOGS/TUNNEL/tor_snx_monitor_v2.log"

mkdir -p "$MONITOR_DIR"
mkdir -p "$TOR_DIR"
mkdir -p "$HS_MONITOR_DIR"
mkdir -p "$(dirname "$LOG_TUNNEL")"

# ------------------------------------------------------------
# Servidor HTTP local para el monitor v2 (puerto 8081)
# ------------------------------------------------------------
cat > "$HOME/soda/02-SISTEMA/DAEMONS/snx_monitor_http_v2.sh" << 'EOF_HTTP'
#!/data/data/com.termux/files/usr/bin/bash

MONITOR_DIR="$HOME/soda/06-MONITOR/V2"
LOG_FILE="$HOME/soda/05-LOGS/MONITOR/monitor_http_v2.log"

mkdir -p "$(dirname "$LOG_FILE")"

cd "$MONITOR_DIR" || exit 1
python -m http.server 8081 >> "$LOG_FILE" 2>&1
EOF_HTTP

chmod +x "$HOME/soda/02-SISTEMA/DAEMONS/snx_monitor_http_v2.sh"

# ------------------------------------------------------------
# torrc para Hidden Service del monitor v2
# ------------------------------------------------------------
cat > "$TORRC_MONITOR" << 'EOF_TORRC'
DataDirectory /data/data/com.termux/files/home/.tor
HiddenServiceDir /data/data/com.termux/files/home/.tor/snx_monitor_service_v2/
HiddenServicePort 80 127.0.0.1:8081
HiddenServiceVersion 3
EOF_TORRC

# ------------------------------------------------------------
# Daemon Tor para Hidden Service del monitor v2
# ------------------------------------------------------------
cat > "$HOME/soda/02-SISTEMA/DAEMONS/snx_tor_monitor_persistent_v2.sh" << 'EOF_DAEMON'
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
EOF_DAEMON

chmod +x "$HOME/soda/02-SISTEMA/DAEMONS/snx_tor_monitor_persistent_v2.sh"

