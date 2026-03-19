#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# SNX — VERIFICADOR DE COHERENCIA ESTRUCTURAL
# Ubicación: /soda/02-SISTEMA/GLOBAL/snx_verificador_coherencia.sh
# Propósito: Comparar estructura esperada vs real.
# ============================================================

BASE="$HOME/soda"
MEMORIA="$BASE/01-MEMORIA/ACTUAL"
OUT="$MEMORIA/coherencia_estructura_report.txt"

mkdir -p "$MEMORIA"

cat > "$OUT" << REP
=== SNX — REPORTE DE COHERENCIA ESTRUCTURAL ===
Fecha: $(date)
Base: $BASE

[CARPETAS ESPERADAS]
00-GOBIERNO
01-MEMORIA
02-SISTEMA
03-OPERACIONES
04-REGISTROS
05-DOCUMENTACION
06-MONITOR

[RESULTADOS]
REP

for d in 00-GOBIERNO 01-MEMORIA 02-SISTEMA 03-OPERACIONES 04-REGISTROS 05-DOCUMENTACION 06-MONITOR; do
  if [ -d "$BASE/$d" ]; then
    echo "[OK] $d existe" >> "$OUT"
  else
    echo "[FALTA] $d NO existe" >> "$OUT"
  fi
done

echo "" >> "$OUT"
echo "[SNX] Reporte generado en: $OUT"

# PIE DE PÁGINA INSTITUCIONAL — SODA‑NEXUS
# No modificar sin aprobación institucional.
