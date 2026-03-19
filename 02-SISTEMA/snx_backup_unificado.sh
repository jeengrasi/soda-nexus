#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# SNX — BACKUP UNIFICADO
# Versión: 1.0
# Fecha: $(date +%Y-%m-%d)
# 
# Fusión de:
# - snx_doc_backup.sh (backup de documentación)
# - snx_restaurar_monitor_github_v1.sh (restauración desde GitHub)
# 
# Funciones:
# - Realizar backup de documentos y configuración
# - Restaurar monitor desde GitHub
# ============================================================

BASE="$HOME/soda"
LOG_DIR="$BASE/04-REGISTROS/SYSTEM"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/backup_$(date +%Y%m%d_%H%M%S).log"

echo "=== BACKUP UNIFICADO ===" | tee -a "$LOG_FILE"
echo "Fecha: $(date)" | tee -a "$LOG_FILE"
echo "=============================================" | tee -a "$LOG_FILE"

# Función: Backup de documentos (de snx_doc_backup.sh)
backup_docs() {
    echo "" | tee -a "$LOG_FILE"
    echo "--- REALIZANDO BACKUP DE DOCUMENTOS ---" | tee -a "$LOG_FILE"
    
    BACKUP_DIR="$BASE/04-REGISTROS/BACKUPS/documentos_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    cp -r "$BASE/00-GOBIERNO" "$BACKUP_DIR/" 2>/dev/null
    cp -r "$BASE/01-MEMORIA" "$BACKUP_DIR/" 2>/dev/null
    cp -r "$BASE/05-DOCUMENTACION" "$BACKUP_DIR/" 2>/dev/null
    
    echo "Backup guardado en: $BACKUP_DIR" | tee -a "$LOG_FILE"
}

# Función: Restaurar monitor desde GitHub (de snx_restaurar_monitor_github_v1.sh)
restaurar_monitor() {
    echo "" | tee -a "$LOG_FILE"
    echo "--- RESTAURANDO MONITOR DESDE GITHUB ---" | tee -a "$LOG_FILE"
    
    if [ -d "$BASE/docs" ]; then
        mv "$BASE/docs" "$BASE/docs_backup_$(date +%Y%m%d_%H%M%S)"
        echo "Backup de docs actual creado" | tee -a "$LOG_FILE"
    fi
    
    git clone https://github.com/jeengrasi/soda-nexus.git "$BASE/docs_tmp"
    cp -r "$BASE/docs_tmp/docs" "$BASE/"
    rm -rf "$BASE/docs_tmp"
    
    echo "Monitor restaurado desde GitHub" | tee -a "$LOG_FILE"
}

# Menú simple (si se ejecuta interactivamente)
if [ "$1" = "backup" ]; then
    backup_docs
elif [ "$1" = "restore" ]; then
    restaurar_monitor
else
    echo "Uso: $0 {backup|restore}"
    echo "  backup  - Realizar backup de documentos"
    echo "  restore - Restaurar monitor desde GitHub"
fi

echo "" | tee -a "$LOG_FILE"
echo "=== OPERACIÓN COMPLETADA ===" | tee -a "$LOG_FILE"
echo "Log guardado en: $LOG_FILE" | tee -a "$LOG_FILE"

# ============================================================
# PIE DE PÁGINA INSTITUCIONAL
# Scripts fusionados:
# - snx_doc_backup.sh
# - snx_restaurar_monitor_github_v1.sh
# ============================================================
