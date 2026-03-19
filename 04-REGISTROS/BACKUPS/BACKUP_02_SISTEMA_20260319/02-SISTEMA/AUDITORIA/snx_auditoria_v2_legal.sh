#!/data/data/com.termux/files/usr/bin/bash
BASE="$HOME/soda"
echo "=== AUDITORÍA SOBERANA REGLA 8 ==="
for i in {00..05}; do
    [ -d "$BASE/0$i" ] && echo "[OK] Ministerio 0$i" || echo "[CRÍTICO] Falta 0$i"
done
echo "=== VERIFICANDO MANDO ÚNICO ==="
[ -f "$BASE/02-SISTEMA/ORQUESTADOR_MAESTRO.py" ] && echo "[OK] Orquestador Presente"
