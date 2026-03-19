#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — ANTIAMNESIA WATCHDOG V2
# Verifica servicios clave y los revive si caen.
# ============================================================================

SODA="$HOME/soda"
LOG_DIR="$SODA/05-REGISTROS/ANTIAMNESIA"
MEM_SCRIPT="$SODA/02-SCRIPTS/ANTIAMNESIA/snx_memoria_central_v2.sh"

mkdir -p "$LOG_DIR"

log() {
    local nivel="$1"
    local msg="$2"
    local ts
    ts="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$ts] [$nivel] $msg" >> "$LOG_DIR/watchdog.log"
}

esta_vivo() {
    pgrep -f "$1" >/dev/null 2>&1
}

puerto_abierto() {
    # best-effort con lsof si existe
    if command -v lsof >/dev/null 2>&1; then
        lsof -i :"$1" >/dev/null 2>&1
    else
        return 0
    fi
}

while true; do
    # 1) Backend monitor
    if ! esta_vivo "snx_monitor_backend"; then
        log "ALERTA" "Backend monitor caído; intentar relanzar."
        if [ -x "$SODA/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend_run_v3.sh" ]; then
            "$SODA/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend_run_v3.sh" >/dev/null 2>&1 &
            log "INFO" "Backend monitor relanzado."
        fi
    fi

    # 2) Servidor HTTP 8080
    if ! puerto_abierto 8080; then
        log "ALERTA" "Servidor HTTP 8080 caído; intentar relanzar."
        if [ -d "$SODA/06-MONITOR/V3" ]; then
            cd "$SODA/06-MONITOR/V3"
            python3 -m http.server 8080 >/dev/null 2>&1 &
            log "INFO" "Servidor HTTP 8080 relanzado."
        fi
    fi

    # 3) Endpoint antiamnesia 5054
    if ! puerto_abierto 5054; then
        if [ -x "$SODA/02-SISTEMA/BACKEND/MONITOR/snx_antiamnesia_endpoint_v1.py" ]; then
            log "ALERTA" "Endpoint antiamnesia 5054 caído; intentar relanzar."
            python3 "$SODA/02-SISTEMA/BACKEND/MONITOR/snx_antiamnesia_endpoint_v1.py" >/dev/null 2>&1 &
            log "INFO" "Endpoint antiamnesia relanzado."
        fi
    fi

    # 4) Latido de memoria (estado + log)
    if [ -x "$MEM_SCRIPT" ]; then
        "$MEM_SCRIPT" estado >/dev/null 2>&1 || true
    fi

    sleep 30
done

# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL — SNX‑2026‑B
# ============================================================================
