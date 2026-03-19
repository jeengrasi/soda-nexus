#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# SNX — DAEMON DE CONTINUIDAD
# Verifica servicios clave y registra estado.
# ============================================================

BASE="$HOME/soda"
MEMORIA="$BASE/01-MEMORIA/ACTUAL"
LOG="$MEMORIA/daemon_continuidad.log"

mkdir -p "$MEMORIA"

check_backend() {
  if curl -s http://127.0.0.1:5050/ping | grep -q '"status": "ok"'; then
    echo "$(date) [OK] Backend responde" >> "$LOG"
  else
    echo "$(date) [ERROR] Backend no responde" >> "$LOG"
  fi
}

while true; do
  echo "=== CICLO CONTINUIDAD $(date) ===" >> "$LOG"
  check_backend
  sleep 300
done

# PIE DE PÁGINA INSTITUCIONAL — SODA‑NEXUS
