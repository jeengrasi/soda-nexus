#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# SODA‑NEXUS — FASE 2
# Tor Hidden Service soberano apuntando a backend v1 (5051)
# Versión: 1.0 — Todo nuevo, nada se modifica
# ============================================================

# [OBS-01] Preparar estructura de Tor y logs
mkdir -p ~/soda/02-SISTEMA/TOR
mkdir -p ~/soda/05-LOGS/TUNNEL
mkdir -p ~/.tor
TOR_TORRC="$HOME/soda/02-SISTEMA/TOR/torrc_snx_v1"
HS_DIR="$HOME/.tor/snx_hidden_service_v1"
LOG_FILE="$HOME/soda/05-LOGS/TUNNEL/tor_snx_v1.log"

# [OBS-02] Instalar Tor si no existe
if ! command -v tor >/dev/null 2>&1; then
  pkg update -y && pkg install -y tor
fi

# [OBS-03] Crear directorio de Hidden Service (sin borrar si ya existe)
mkdir -p "$HS_DIR"

# [OBS-04] Generar torrc soberano para SODA‑NEXUS (backend v1 en 5051)
cat > "$TOR_TORRC" << 'EOF_TORRC'
# ============================================================
# torrc_snx_v1 — Configuración Tor para SODA‑NEXUS
# Hidden Service apuntando a backend v1 (127.0.0.1:5051)
# ============================================================

DataDirectory /data/data/com.termux/files/home/.tor

HiddenServiceDir /data/data/com.termux/files/home/.tor/snx_hidden_service_v1/
HiddenServicePort 80 127.0.0.1:5051
HiddenServiceVersion 3

Log notice file /data/data/com.termux/files/home/soda/05-LOGS/TUNNEL/tor_snx_v1_runtime.log
EOF_TORRC

# [OBS-05] Script daemon persistente para Tor
cat > ~/soda/02-SISTEMA/DAEMONS/snx_tor_persistent_v1.sh << 'EOF_DAEMON'
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
EOF_DAEMON

chmod +x ~/soda/02-SISTEMA/DAEMONS/snx_tor_persistent_v1.sh

# [OBS-06] Registro de Fase 2
echo "[FASE 2] Tor Hidden Service v1 creado el $(date)" >> ~/soda/05-LOGS/FASE2.log

# ============================================================
# PIE INSTITUCIONAL — SODA‑NEXUS
# FASE 2: Tor Hidden Service soberano v1 (backend 5051).
# No sobrescribe nada previo. Solo crea, nunca destruye.
# ============================================================
