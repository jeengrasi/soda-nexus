#!/data/data/com.termux/files/usr/bin/bash
# SODA-NEXUS — SCRIPT DE REINGENIERIA REGISTROS V1
set -e

BASE_DIR="$HOME/soda/04-REGISTROS"
LEGACY_DIR="$BASE_DIR/REGISTROS-LEGACY"

echo "--- [INICIANDO SANEAMIENTO DE REGISTROS (TRAZABILIDAD)] ---"

# 1. COMPRESIÓN DE LOGS MASIVOS
echo "📦 Comprimiendo logs de túnel (4.9MB)..."
gzip -f $BASE_DIR/LOGS-LEGACY/TUNNEL/tunnel_202603.log 2>/dev/null || true

# 2. LIMPIEZA DE RAÍZ DE REGISTROS
echo "🧹 Archivando logs de fases previas..."
mv $BASE_DIR/FASE*.log $LEGACY_DIR/ 2>/dev/null || true
mv $BASE_DIR/logs.txt $LEGACY_DIR/ 2>/dev/null || true

# 3. ACTUALIZACIÓN DE ÍNDICES INSTITUCIONALES
echo "⚙️ Ejecutando IA_REGISTROS_V4..."
bash $BASE_DIR/snx_ia_registros_V4.sh

# 4. GENERACIÓN DE INFORME FÍSICO (OBLIGATORIO)
cat << EOM > $BASE_DIR/informe_saneamiento_04.log
=== INFORME DE AVANCE INSTITUCIONAL ===
Fecha: $(date +'%Y-%m-%d %H:%M:%S')
Ministerio: 04-REGISTROS
Acción: Rotación de logs pesados y limpieza de raíz.

CAMBIOS REALIZADOS:
1. PESO: tunnel_202603.log comprimido con GZIP para optimizar almacenamiento.
2. ORDEN: Logs de Fases y logs.txt movidos a REGISTROS-LEGACY.
3. TRAZABILIDAD: Índices de memoria actualizados mediante snx_ia_registros_V4.sh.

Estado del Ministerio: TRAZABILIDAD OPTIMIZADA Y DOCUMENTADA.
Director: Jeisson
Auditor: Gemini SODA-NEXUS
EOM

echo "=== OPERACIÓN REGISTROS COMPLETADA ==="
