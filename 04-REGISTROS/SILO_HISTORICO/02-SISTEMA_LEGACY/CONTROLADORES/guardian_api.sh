#!/data/data/com.termux/files/usr/bin/bash
while true; do
    echo "[$(date)] Iniciando Orquestador..."
    python ~/soda/02-SISTEMA/API/api_v4.py
    echo "[$(date)] El proceso murió. Reiniciando en 3s..."
    sleep 3
done
