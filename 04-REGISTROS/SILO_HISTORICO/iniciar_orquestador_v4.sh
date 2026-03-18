#!/data/data/com.termux/files/usr/bin/bash

echo "==============================================="
echo "   INICIANDO ORQUESTADOR SODA-NEXUS V4"
echo "==============================================="

pkill -f api_v4.py 2>/dev/null

python3 ~/soda/02-SISTEMA/API/api_v4.py &
PID=$!

echo "Orquestador V4 iniciado con PID: $PID"
echo "Puerto: 5051"
