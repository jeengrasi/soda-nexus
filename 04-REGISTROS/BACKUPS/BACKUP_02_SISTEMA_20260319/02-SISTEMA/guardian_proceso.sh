#!/bin/bash
while true; do
  termux-wake-lock
  echo "[$(date)] Sistema SODA Activo - Protegiendo procesos" >> ~/soda/05-LOGS/guardian.log
  sleep 60
done
