#!/data/data/com.termux/files/usr/bin/bash

STATE="$HOME/soda/STATE/state.json"
LOGS="$HOME/soda/STATE/logs.txt"

while true; do
  NOW=$(date '+%Y-%m-%d %H:%M:%S')

  # Actualizar logs
  echo "$NOW - Daemon activo" >> "$LOGS"

  # Actualizar estado
  jq --arg time "$NOW" \
     '.last_update = $time' \
     "$STATE" > "$STATE.tmp" && mv "$STATE.tmp" "$STATE"

  sleep 5
done
