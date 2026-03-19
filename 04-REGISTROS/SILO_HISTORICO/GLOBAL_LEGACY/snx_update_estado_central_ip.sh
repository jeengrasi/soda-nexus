#!/data/data/com.termux/files/usr/bin/bash
# SNX — ACTUALIZAR ESTADO CENTRAL CON IP LAN Y URL DEL MONITOR

BASE="$HOME/soda"
STATE_DIR="$BASE/STATE"
MEMORIA="$BASE/01-MEMORIA/ACTUAL"
IP_FILE="$MEMORIA/ip_lan_actual.txt"
ESTADO="$STATE_DIR/estado_central.json"

mkdir -p "$STATE_DIR"

IP_LAN=""
[ -f "$IP_FILE" ] && IP_LAN="$(cat "$IP_FILE" | head -n1)"

if [ -z "$IP_LAN" ]; then
  echo "[SNX] No hay IP LAN registrada en $IP_FILE" >&2
  exit 1
fi

TMP="$ESTADO.tmp"

if [ -f "$ESTADO" ]; then
  jq --arg ip "$IP_LAN" \
     --arg monitor_url "http://$IP_LAN:8080" \
     --arg backend_url "http://$IP_LAN:5050" \
     '.ip_lan = $ip
      | .monitor.monitor_url = $monitor_url
      | .backend.backend_url = $backend_url' \
     "$ESTADO" > "$TMP" && mv "$TMP" "$ESTADO"
else
  jq -n \
    --arg ip "$IP_LAN" \
    --arg monitor_url "http://$IP_LAN:8080" \
    --arg backend_url "http://$IP_LAN:5050" \
    '{
      version: "V1",
      ip_lan: $ip,
      backend: { backend_url: $backend_url },
      monitor: { monitor_url: $monitor_url }
    }' > "$ESTADO"
fi

echo "[SNX] estado_central.json actualizado con IP LAN: $IP_LAN"

# PIE DE PÁGINA INSTITUCIONAL — SODA‑NEXUS
