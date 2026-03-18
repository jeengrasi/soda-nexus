#!/data/data/com.termux/files/usr/bin/bash
# SNX — DETECCIÓN DE IP LAN
# Guarda la IP LAN actual en: /soda/01-MEMORIA/ACTUAL/ip_lan_actual.txt

BASE="$HOME/soda"
MEMORIA="$BASE/01-MEMORIA/ACTUAL"
OUT="$MEMORIA/ip_lan_actual.txt"

mkdir -p "$MEMORIA"

IP_LAN=$(ip addr show wlan0 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1 | head -n1)

if [ -z "$IP_LAN" ]; then
  IP_LAN=$(ip addr show 2>/dev/null | awk '/inet / && $2 !~ /^127/ {print $2}' | cut -d/ -f1 | head -n1)
fi

if [ -n "$IP_LAN" ]; then
  echo "$IP_LAN" > "$OUT"
  echo "[SNX] IP LAN detectada: $IP_LAN (guardada en $OUT)"
else
  echo "[SNX] No se pudo detectar IP LAN" >&2
fi

# PIE DE PÁGINA INSTITUCIONAL — SODA‑NEXUS
