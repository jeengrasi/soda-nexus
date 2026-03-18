#!/bin/bash

BASE="$HOME/soda"
CENTRAL="$BASE/02-SISTEMA/BACKEND/snx_ia_central.sh"
PUSH="$BASE/02-SISTEMA/BACKEND/snx_push_state.sh"
LOG="$BASE/00-GOBIERNO/LOGS/daemon.log"

timestamp() { date +"%Y-%m-%d %H:%M:%S"; }

echo "$(timestamp) — DAEMON INICIADO" >> "$LOG"

while true; do
  echo "$(timestamp) — Ejecutando IA‑SCRIPT CENTRAL" >> "$LOG"
  bash "$CENTRAL"

  echo "$(timestamp) — Subiendo estado a GitHub" >> "$LOG"
  bash "$PUSH"

  echo "$(timestamp) — Ciclo completo" >> "$LOG"
  sleep 60
done
