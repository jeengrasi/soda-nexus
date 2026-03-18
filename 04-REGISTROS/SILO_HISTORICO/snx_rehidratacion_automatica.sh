#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# SNX — REHIDRATACIÓN AUTOMÁTICA DE CONTEXTO
# Ubicación: /soda/02-SISTEMA/GLOBAL/snx_rehidratacion_automatica.sh
# Propósito: Unificar contexto crítico para IA y sistema.
# ============================================================

BASE="$HOME/soda"
MEMORIA="$BASE/01-MEMORIA/ACTUAL"
GOBIERNO_META="$BASE/00-GOBIERNO/META"
MONITOR_DATA="$BASE/06-MONITOR/V3/monitor_data.json"
OUT="$MEMORIA/contexto_unificado_IA.json"

mkdir -p "$MEMORIA"

proposito="$GOBIERNO_META/PROPOSITO-SOBERANO-V1.md"
antiamnesia="$BASE/00-GOBIERNO/SNX-ANTIAMNESIA-V1.md"
resumen="$MEMORIA/SNX-RESUMEN-ACTUAL.md"
paquete="$MEMORIA/SNX-PAQUETE-IA-ACTUAL.md"

jq -n \
  --arg proposito "$( [ -f "$proposito" ] && cat "$proposito" || echo "" )" \
  --arg antiamnesia "$( [ -f "$antiamnesia" ] && cat "$antiamnesia" || echo "" )" \
  --arg resumen "$( [ -f "$resumen" ] && cat "$resumen" || echo "" )" \
  --arg paquete "$( [ -f "$paquete" ] && cat "$paquete" || echo "" )" \
  --arg monitor_data "$( [ -f "$MONITOR_DATA" ] && cat "$MONITOR_DATA" || echo "{}" )" \
  '{
    proposito_soberano_md: $proposito,
    antiamnesia_md: $antiamnesia,
    resumen_actual_md: $resumen,
    paquete_ia_md: $paquete,
    monitor_data_json: $monitor_data
  }' > "$OUT"

echo "[SNX] Contexto unificado generado en: $OUT"

# PIE DE PÁGINA INSTITUCIONAL — SODA‑NEXUS
# No modificar sin aprobación institucional.
# Ejecutar desde Termux. Usar en la mayoría de sesiones de IA.
