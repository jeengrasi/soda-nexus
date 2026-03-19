#!/data/data/com.termux/files/usr/bin/bash
STATE="$HOME/soda/00-VAULT/state.json"
REPORT="$HOME/soda/05-LOGS/SYSTEM/reader_$(date +%Y%m%d_%H%M).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$REPORT"
}

log "=== LECTOR INSTITUCIONAL SODA‑NEXUS ==="

if [ ! -f "$STATE" ]; then
    log "❌ state.json NO existe. Creando archivo base..."
    cat > "$STATE" << 'JSON'
{
    "version": "1.0",
    "last_audit": null,
    "services": {},
    "tunnel": {},
    "backend": {},
    "notes": []
}
JSON
fi

log "✔ state.json existe"

log "Servicios runit:"
sv status | tee -a "$REPORT"

if curl -s http://localhost:5050/ping > /dev/null; then
    log "✔ Backend activo"
else
    log "❌ Backend inactivo"
fi

if [ -f "$HOME/soda/00-VAULT/tunnel.env" ]; then
    log "Túnel detectado:"
    cat "$HOME/soda/00-VAULT/tunnel.env" | tee -a "$REPORT"
else
    log "❌ No hay túnel registrado"
fi

log "Actualizando state.json..."
jq --arg time "$(date '+%Y-%m-%d %H:%M:%S')" \
   '.last_audit = $time' \
   "$STATE" > "$STATE.tmp" && mv "$STATE.tmp" "$STATE"

log "✔ state.json actualizado"
