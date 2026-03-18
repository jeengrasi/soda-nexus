#!/data/data/com.termux/files/usr/bin/bash

PORT=5050
STATE="$HOME/soda/STATE/state.json"
LOGS="$HOME/soda/STATE/logs.txt"

while true; do
  # Escuchar una conexión y capturar la petición completa
  REQUEST=$(nc -l -q 0 $PORT)

  if echo "$REQUEST" | grep -q "GET /state"; then
    RESPONSE=$(cat "$STATE")
    echo -e "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n$RESPONSE" | nc -q 0 -l $PORT

  elif echo "$REQUEST" | grep -q "GET /logs"; then
    RESPONSE=$(tail -n 50 "$LOGS")
    echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n$RESPONSE" | nc -q 0 -l $PORT

  else
    echo -e "HTTP/1.1 404 Not Found\r\n\r\n" | nc -q 0 -l $PORT
  fi

done
