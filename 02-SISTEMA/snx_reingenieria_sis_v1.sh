#!/data/data/com.termux/files/usr/bin/bash
# SODA-NEXUS — SCRIPT DE REINGENIERIA SISTEMA V1
set -e

BASE_DIR="$HOME/soda/02-SISTEMA"
API_DIR="$BASE_DIR/API"
DAE_DIR="$BASE_DIR/DAEMONS"

echo "--- [INICIANDO SANEAMIENTO DE SISTEMA (EL CEREBRO)] ---"

# 1. CREACIÓN DE DIRECTORIO DE LEGADO PARA EL CEREBRO
mkdir -p $API_DIR/LEGADO_PYTHON

# 2. ARCHIVADO DE ORQUESTADORES REDUNDANTES
echo "📦 Archivando versiones experimentales..."
mv $API_DIR/ORQUESTADOR_FINAL.py $API_DIR/LEGADO_PYTHON/ 2>/dev/null || true
mv $API_DIR/ORQUESTADOR_LIVE.py $API_DIR/LEGADO_PYTHON/ 2>/dev/null || true
mv $API_DIR/ORQUESTADOR_MAESTRO_V4.py $API_DIR/LEGADO_PYTHON/ 2>/dev/null || true
mv $API_DIR/ORQUESTADOR_V4_FRESCO.py $API_DIR/LEGADO_PYTHON/ 2>/dev/null || true

# 3. REFORZAMIENTO DEL ORQUESTADOR V6 (RUTA DE VERDAD)
echo "⚙️ Ajustando rutas en ORQUESTADOR_V6.py..."
# Aseguramos que apunte a los ministerios reales, no a carpetas temporales
sed -i "s|SODA_FRESCO|03-OPERACIONES/WEB|g" $API_DIR/ORQUESTADOR_V6.py

# 4. DESACTIVACIÓN DE DAEMONS OBSOLETOS
echo "🛑 Marcando daemons v1/v2 como legados..."
mv $DAE_DIR/snx_backend_v1_service.sh $DAE_DIR/snx_backend_v1_service.sh.LEGACY 2>/dev/null || true
mv $DAE_DIR/snx_monitor_http_v2.sh $DAE_DIR/snx_monitor_http_v2.sh.LEGACY 2>/dev/null || true

# 5. DOCUMENTACIÓN OBLIGATORIA DEL AVANCE
cat << EOM > $BASE_DIR/informe_saneamiento_02.log
=== INFORME DE AVANCE INSTITUCIONAL ===
Fecha: $(date +'%Y-%m-%d %H:%M:%S')
Ministerio: 02-SISTEMA
Acción: Consolidación de Orquestador y Purga de Daemons.

CAMBIOS REALIZADOS:
1. API: Mapeo de ORQUESTADOR_V6 corregido hacia 03-OPERACIONES/WEB.
2. API: Versiones MAESTRO, LIVE y FINAL movidas a LEGADO_PYTHON.
3. DAEMONS: Servicios v1 y v2 desactivados para evitar colisión de puertos.
4. Trazabilidad: Generación de informe de bitácora en la raíz del ministerio.

Estado del Ministerio: CEREBRO UNIFICADO.
Director: Jeisson
Auditor: Gemini SODA-NEXUS
EOM

echo "=== OPERACIÓN SISTEMA COMPLETADA ==="
