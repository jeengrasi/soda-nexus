#!/data/data/com.termux/files/usr/bin/bash
# SODA-NEXUS — SCRIPT DE REINGENIERIA OPERACIONES V1
set -e

BASE_DIR="$HOME/soda/03-OPERACIONES"
WEB_DIR="$BASE_DIR/WEB"

echo "--- [INICIANDO SANEAMIENTO DE OPERACIONES (EL MÚSCULO)] ---"

# 1. RESCATANDO LA VERSIÓN MAESTRA (V4)
echo "🏗️ Restaurando Interfaz V4 a la ruta de producción..."
cp $WEB_DIR/monitor-v4.LEGACY_PROCESADO/index-v4.html $WEB_DIR/index.html
cp $WEB_DIR/monitor-v4.LEGACY_PROCESADO/monitor-v4.js $WEB_DIR/monitor.js
cp $WEB_DIR/monitor-v4.LEGACY_PROCESADO/config-v4.js $WEB_DIR/config.js
cp $WEB_DIR/monitor-v4.LEGACY_PROCESADO/panel-institucional-v4.js $WEB_DIR/panel-institucional.js
cp $WEB_DIR/monitor-v4.LEGACY_PROCESADO/snx-logs-v4.js $WEB_DIR/snx-logs.js

# 2. LIMPIEZA DE CARPETAS VACÍAS Y REDUNDANTES
echo "🧹 Eliminando directorios vacíos..."
rmdir $WEB_DIR/MONITOR_V4_FRESCO 2>/dev/null || true

# 3. GENERACIÓN DE INFORME FÍSICO (OBLIGATORIO)
cat << EOM > $BASE_DIR/informe_saneamiento_03.log
=== INFORME DE AVANCE INSTITUCIONAL ===
Fecha: $(date +'%Y-%m-%d %H:%M:%S')
Ministerio: 03-OPERACIONES
Acción: Restauración de Interfaz V4 y Saneamiento de WEB.

CAMBIOS REALIZADOS:
1. WEB: Archivos de V4 restaurados en la raíz de /WEB/ (index.html, monitor.js, config.js).
2. WEB: Eliminada carpeta vacía MONITOR_V4_FRESCO.
3. INTEGRIDAD: La interfaz ahora coincide con la ruta buscada por el Orquestador V6.

Estado del Ministerio: INTERFAZ RESTAURADA Y DOCUMENTADA.
Director: Jeisson
Auditor: Gemini SODA-NEXUS
EOM

echo "=== OPERACIÓN OPERACIONES COMPLETADA ==="
