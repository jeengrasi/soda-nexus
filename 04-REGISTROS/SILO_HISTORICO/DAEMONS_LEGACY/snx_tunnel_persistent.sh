#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# SODA‑NEXUS — snx_tunnel_persistent.sh
# Daemon soberano para túnel Pinggy 24/7, no interactivo
# ============================================================

LOGFILE="$HOME/soda/05-LOGS/TUNNEL/tunnel_$(date +%Y%m).log"   # OBS-001: Log mensual
STATEFILE="$HOME/soda/00-VAULT/tunnel.env"                     # OBS-002: URL pública
BACKEND_PORT=5050                                              # OBS-003: Puerto backend
PINGGY_HOST="a.pinggy.io"                                      # OBS-004: Host Pinggy
PINGGY_PORT=443                                                # OBS-005: Puerto Pinggy

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [TUNNEL] $1" | tee -a "$LOGFILE"; }  # OBS-006

check_backend() {                                               # OBS-007: Healthcheck backend
    curl -s --max-time 3 "http://localhost:${BACKEND_PORT}/ping" > /dev/null
}

start_tunnel() {                                                # OBS-008: Túnel NO interactivo
    log "Iniciando túnel NO interactivo..."
    ssh -N -f \
        -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -p "${PINGGY_PORT}" \
        -R0:localhost:${BACKEND_PORT} \
        "${PINGGY_HOST}" \
        2>> "$LOGFILE"

    if [ $? -eq 0 ]; then
        log "Túnel iniciado. Capturando URL..."
        capture_url
    else
        log "ERROR: Falló inicio del túnel"
    fi
}

capture_url() {                                                 # OBS-009: Extraer URL del log
    URL=$(tail -n 200 "$LOGFILE" | grep -oE 'https://[^ ]*pinggy\.link' | tail -1)
    if [ -n "$URL" ]; then
        echo "TUNNEL_URL=\"$URL\"" > "$STATEFILE"
        chmod 600 "$STATEFILE"
        log "URL capturada: $URL"
    else
        log "ADVERTENCIA: No se encontró URL"
    fi
}

check_tunnel() {                                                # OBS-010: Verificar proceso ssh
    pgrep -f "ssh.*${PINGGY_HOST}.*${BACKEND_PORT}" > /dev/null
}

restart_tunnel() {                                              # OBS-011: Reinicio limpio
    log "Reiniciando túnel..."
    pkill -9 -f "ssh.*${PINGGY_HOST}" 2>/dev/null || true
    sleep 2
    start_tunnel
}

main_loop() {                                                   # OBS-012: Supervisor 24/7
    log "=== Supervisor de túnel SODA‑NEXUS iniciado ==="

    if command -v termux-wake-lock > /dev/null; then
        termux-wake-lock 2>/dev/null
        log "Wake-lock activado"
    fi

    while true; do
        if check_backend; then
            if check_tunnel; then
                log "Túnel activo"
            else
                log "Túnel caído; reiniciando..."
                restart_tunnel
            fi
        else
            log "Backend inactivo; reintentando..."
        fi
        sleep 30
    done
}

trap "pkill -9 -f 'ssh.*${PINGGY_HOST}' 2>/dev/null; termux-wake-unlock 2>/dev/null; exit 0" SIGINT SIGTERM  # OBS-013

main_loop                                                        # OBS-014

# ============================================================
# FOOTER INSTITUCIONAL
# SODA‑NEXUS — Túnel Pinggy 24/7, inmune a TTY, supervisado,
# auto-reparable, auditable y soberano.
# ============================================================
