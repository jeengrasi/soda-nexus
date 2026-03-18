#!/data/data/com.termux/files/usr/bin/bash

BASE="$HOME/soda"
MEMORIA="$BASE/01-MEMORIA/ACTUAL"
LOG="$MEMORIA/daemon_antiamnesia.log"

check() {
  if [ -f "$1" ]; then
    echo "$(date) [OK] $1" >> "$LOG"
  else
    echo "$(date) [FALTA] $1" >> "$LOG"
  fi
}

while true; do
  check "$MEMORIA/ip_lan_actual.txt"
  check "$BASE/00-GOBIERNO/META/ACCESO-MONITOR.md"
  check "$BASE/STATE/estado_central.json"
  sleep 300
done
