#!/data/data/com.termux/files/usr/bin/bash

VAULT="$HOME/soda/00-VAULT/tunnel.env"
LOGFILE="$HOME/soda/05-LOGS/TUNNEL/tunnel_$(date +%Y%m%d).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

log "=== SODA‑NEXUS | Iniciando daemon de túnel Pinggy ==="

# 1. Verificar backend por puerto
if ! lsof -i:5050 > /dev/null 2>&1; then
    log "Backend no activo. Esperando servicio snx-backend..."
    sleep 5
fi

# 2. Iniciar túnel Pinggy
while true; do
    log "Iniciando túnel Pinggy..."

    URL=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 443 -R0:localhost:5050 a.pinggy.io 2>&1 | grep -o 'https://[^ ]*pinggy\.link')

    if [ -n "$URL" ]; then
        log "Túnel activo: $URL"
        echo "TUNNEL_URL=\"$URL\"" > "$VAULT"
        chmod 600 "$VAULT"
    else
        log "ERROR: No se pudo obtener URL. Reintentando..."
    fi

    log "Esperando reconexión si el túnel cae..."
    sleep 5
done

