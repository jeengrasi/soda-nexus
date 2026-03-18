#!/data/data/com.termux/files/usr/bin/bash

LOG="$HOME/soda/01-MEMORIA/ACTUAL/daemon_monitor_watchdog.log"

while true; do
  if ! pgrep -f "http.server 8080" > /dev/null; then
    echo "[WATCHDOG] Monitor caído — reiniciando" >> "$LOG"
    sv up monitor
  fi
  sleep 60
done
