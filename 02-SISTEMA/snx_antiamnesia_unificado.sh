#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# SNX — ANTIAMNESIA UNIFICADO DEL SISTEMA
# Versión: 1.0
# Fecha: $(date +%Y-%m-%d)
# 
# Fusión de:
# - snx_memoria_central_v2.sh (base)
# - snx_memoria_central_v1.sh
# - snx_integridad.sh
# - snx_antiamnesia_watchdog_v1.sh
# - snx_antiamnesia_integracion_sagrados_v1.sh
# - snx_verificar_archivos_sagrados_v1.sh
# 
# Funciones:
# - Generar resumen del sistema para IA
# - Verificar integridad de archivos sagrados
# - Monitorear cambios críticos
# - Mantener contexto vivo
# ============================================================

# Configuración
BASE="$HOME/soda"
MEMORIA_ACTUAL="$BASE/01-MEMORIA/ACTUAL"
LOG_DIR="$BASE/04-REGISTROS/SYSTEM"
mkdir -p "$MEMORIA_ACTUAL" "$LOG_DIR"

LOG_FILE="$LOG_DIR/antiamnesia_$(date +%Y%m%d_%H%M%S).log"
CONTEXTO_FILE="$MEMORIA_ACTUAL/contexto_actual.json"

echo "=== ANTIAMNESIA UNIFICADO ===" | tee -a "$LOG_FILE"
echo "Fecha: $(date)" | tee -a "$LOG_FILE"
echo "=============================================" | tee -a "$LOG_FILE"

# 1. Verificar archivos sagrados (de snx_verificar_archivos_sagrados_v1.sh)
echo "" | tee -a "$LOG_FILE"
echo "--- VERIFICANDO ARCHIVOS SAGRADOS ---" | tee -a "$LOG_FILE"
SAGRADOS=(
    "$BASE/00-GOBIERNO/CONSTITUCION.md"
    "$BASE/00-GOBIERNO/ESTADO/snx_state.json"
    "$BASE/02-SISTEMA/snx_control_unico.sh"
    "$BASE/02-SISTEMA/snx_auditor_unificado.sh"
)

for archivo in "${SAGRADOS[@]}"; do
    if [ -f "$archivo" ]; then
        echo "[OK] $archivo" | tee -a "$LOG_FILE"
    else
        echo "[FALTA] $archivo" | tee -a "$LOG_FILE"
    fi
done

# 2. Verificar integridad (de snx_integridad.sh)
echo "" | tee -a "$LOG_FILE"
echo "--- VERIFICANDO INTEGRIDAD DE MINISTERIOS ---" | tee -a "$LOG_FILE"
for m in 00-GOBIERNO 01-MEMORIA 02-SISTEMA 03-OPERACIONES 04-REGISTROS 05-DOCUMENTACION docs; do
    if [ -d "$BASE/$m" ]; then
        count=$(find "$BASE/$m" -type f 2>/dev/null | wc -l)
        echo "[$m] $count archivos" | tee -a "$LOG_FILE"
    else
        echo "[ERROR] $m no existe" | tee -a "$LOG_FILE"
    fi
done

# 3. Generar contexto para IA (de snx_memoria_central_v2.sh)
echo "" | tee -a "$LOG_FILE"
echo "--- GENERANDO CONTEXTO PARA IA ---" | tee -a "$LOG_FILE"

# Obtener estado del backend
if pgrep -f "snx_monitor_backend.py" > /dev/null; then
    BACKEND="ACTIVO"
else
    BACKEND="INACTIVO"
fi

# Obtener IP local
IP_LOCAL=$(ip addr show | grep -oP '(?<=inet\s)\d+\.\d+\.\d+\.\d+' | grep -v 127.0.0.1 | head -1)

# Crear archivo de contexto
cat > "$CONTEXTO_FILE" << EOC
{
    "timestamp": "$(date +%Y-%m-%d_%H:%M:%S)",
    "backend": "$BACKEND",
    "ip_local": "$IP_LOCAL",
    "ministerios": {
        "00-GOBIERNO": $(find "$BASE/00-GOBIERNO" -type f 2>/dev/null | wc -l),
        "01-MEMORIA": $(find "$BASE/01-MEMORIA" -type f 2>/dev/null | wc -l),
        "02-SISTEMA": $(find "$BASE/02-SISTEMA" -type f 2>/dev/null | wc -l),
        "03-OPERACIONES": $(find "$BASE/03-OPERACIONES" -type f 2>/dev/null | wc -l),
        "04-REGISTROS": $(find "$BASE/04-REGISTROS" -type f 2>/dev/null | wc -l),
        "05-DOCUMENTACION": $(find "$BASE/05-DOCUMENTACION" -type f 2>/dev/null | wc -l),
        "docs": $(find "$BASE/docs" -type f 2>/dev/null | wc -l)
    }
}
EOC

echo "Contexto guardado en: $CONTEXTO_FILE" | tee -a "$LOG_FILE"

# 4. Watchdog ligero (de snx_antiamnesia_watchdog_v1.sh)
echo "" | tee -a "$LOG_FILE"
echo "--- VERIFICANDO SERVICIOS CRÍTICOS ---" | tee -a "$LOG_FILE"

# Verificar controlador único
if pgrep -f "snx_control_unico.sh" > /dev/null; then
    echo "[OK] Controlador único activo" | tee -a "$LOG_FILE"
else
    echo "[AVISO] Controlador único no está corriendo" | tee -a "$LOG_FILE"
fi

# 5. Resumen final
echo "" | tee -a "$LOG_FILE"
echo "=== ANTIAMNESIA COMPLETADA ===" | tee -a "$LOG_FILE"
echo "Log guardado en: $LOG_FILE" | tee -a "$LOG_FILE"
echo "Contexto actualizado en: $CONTEXTO_FILE" | tee -a "$LOG_FILE"

# ============================================================
# PIE DE PÁGINA INSTITUCIONAL
# Este script unifica las funcionalidades de los scripts
# originales que ahora están en SILO_HISTORICO.
# 
# Scripts fusionados:
# - snx_memoria_central_v1.sh
# - snx_memoria_central_v2.sh
# - snx_integridad.sh
# - snx_antiamnesia_watchdog_v1.sh
# - snx_antiamnesia_integracion_sagrados_v1.sh
# - snx_verificar_archivos_sagrados_v1.sh
# ============================================================
