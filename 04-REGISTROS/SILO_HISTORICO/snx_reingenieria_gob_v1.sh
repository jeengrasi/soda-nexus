#!/data/data/com.termux/files/usr/bin/bash
# SODA-NEXUS — SCRIPT DE REINGENIERIA GOBIERNO V1
set -e

GOB_DIR="$HOME/soda/00-GOBIERNO"
IP_REAL="192.168.12.183"
PUERTO="15051"

echo "--- [INICIANDO SANEAMIENTO DE GOBIERNO] ---"

# 1. CORRECCIÓN DE PUERTOS Y RED EN JSONs
echo "📡 Sincronizando IP y Puertos en ESTADO..."
sed -i "s/127.0.0.1/$IP_REAL/g" $GOB_DIR/ESTADO/*.json
sed -i "s/http:\/\/127.0.0.1:15051/http:\/\/$IP_REAL:$PUERTO/g" $GOB_DIR/ESTADO/*.json
# Forzar puerto correcto en manifiesto
sed -i "s/\"puerto_soberano\": [0-9]*/\"puerto_soberano\": $PUERTO/g" $GOB_DIR/ESTADO/MANIFIESTO_SOBERANO_V4.json

# 2. ACTUALIZACIÓN DE DOCUMENTOS META (LA LEY)
echo "📜 Actualizando Manuales de Acceso y Propósito..."
sed -i "s/8080/$PUERTO/g" $GOB_DIR/META/ACCESO-MONITOR.md
sed -i "s/5050/$PUERTO/g" $GOB_DIR/META/ACCESO-MONITOR.md
echo "- Saneamiento V1 ejecutado el $(date)" >> $GOB_DIR/META/PROPOSITO-SOBERANO-V1.md

# 3. LIMPIEZA DE ARCHIVOS PROCESADOS EN RAÍZ
echo "🧹 Purgando archivos .PROCESADO de la raíz..."
mv $HOME/soda/*.PROCESADO $HOME/soda/04-REGISTROS/LOGS-LEGACY/ 2>/dev/null || true

# 4. REINICIO DE LOGS INSTITUCIONALES
echo "📝 Reactivando trazabilidad en LOGS..."
echo "=== REINICIO DE GOBIERNO V1: $(date) ===" > $GOB_DIR/LOGS/central.log

# 5. REGISTRO DE DECISIÓN SOBERANA
echo "[$(date)] Saneamiento integral de Gobierno y Redirección de Puertos V1" >> $GOB_DIR/DECISIONES/decisiones.log

echo "=== OPERACIÓN SODA-ZERO GOBIERNO COMPLETADA ==="
