#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# SNX — GITHUB UNIFICADO
# Versión: 1.0
# Fecha: $(date +%Y-%m-%d)
# 
# Fusión de:
# - SNX-PUBLISH-MONITOR.sh (publicar monitor)
# - snx_migracion_github_v1.sh (migrar a GitHub)
# - snx_pages_config_v1.sh (configurar GitHub Pages)
# - snx_unificador_soberano_v1.sh (unificar estructura)
# 
# Funciones:
# - Publicar monitor en GitHub
# - Migrar cambios a GitHub
# - Configurar GitHub Pages
# - Unificar estructura antes de publicar
# ============================================================

BASE="$HOME/soda"
LOG_DIR="$BASE/04-REGISTROS/SYSTEM"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/github_$(date +%Y%m%d_%H%M%S).log"

echo "=== GITHUB UNIFICADO ===" | tee -a "$LOG_FILE"
echo "Fecha: $(date)" | tee -a "$LOG_FILE"
echo "=============================================" | tee -a "$LOG_FILE"

# Función: Verificar y cargar token de GitHub
cargar_token() {
    if [ -f "$BASE/00-GOBIERNO/VAULT/github.env" ]; then
        source "$BASE/00-GOBIERNO/VAULT/github.env"
        echo "Token cargado desde VAULT" | tee -a "$LOG_FILE"
    else
        echo "ERROR: No se encontró github.env en VAULT" | tee -a "$LOG_FILE"
        exit 1
    fi
}

# Función: Unificar estructura (de snx_unificador_soberano_v1.sh)
unificar_estructura() {
    echo "" | tee -a "$LOG_FILE"
    echo "--- UNIFICANDO ESTRUCTURA ---" | tee -a "$LOG_FILE"
    
    # Mover scripts sueltos de la raíz a 02-SISTEMA (si existen)
    for script in snx_*.sh; do
        if [ -f "$BASE/$script" ] && [ ! -f "$BASE/02-SISTEMA/$script" ]; then
            mv "$BASE/$script" "$BASE/02-SISTEMA/" 2>/dev/null
            echo "Movido: $script a 02-SISTEMA" | tee -a "$LOG_FILE"
        fi
    done
    
    echo "Estructura unificada" | tee -a "$LOG_FILE"
}

# Función: Configurar GitHub Pages (de snx_pages_config_v1.sh)
configurar_pages() {
    echo "" | tee -a "$LOG_FILE"
    echo "--- CONFIGURANDO GITHUB PAGES ---" | tee -a "$LOG_FILE"
    
    # Crear .nojekyll si no existe
    touch "$BASE/docs/.nojekyll"
    
    # Verificar que docs/index.html existe
    if [ ! -f "$BASE/docs/index.html" ]; then
        echo "ERROR: docs/index.html no existe" | tee -a "$LOG_FILE"
        return 1
    fi
    
    echo "GitHub Pages configurado (rama master, carpeta /docs)" | tee -a "$LOG_FILE"
}

# Función: Migrar a GitHub (de snx_migracion_github_v1.sh)
migrar_github() {
    echo "" | tee -a "$LOG_FILE"
    echo "--- MIGRANDO A GITHUB ---" | tee -a "$LOG_FILE"
    
    cd "$BASE"
    
    # Verificar si hay cambios
    if git status --porcelain | grep -q .; then
        git add .
        git commit -m "SNX: Actualización automática - $(date)"
        git push origin master
        echo "Cambios subidos a GitHub" | tee -a "$LOG_FILE"
    else
        echo "No hay cambios para subir" | tee -a "$LOG_FILE"
    fi
}

# Función: Publicar monitor (de SNX-PUBLISH-MONITOR.sh)
publicar_monitor() {
    echo "" | tee -a "$LOG_FILE"
    echo "--- PUBLICANDO MONITOR ---" | tee -a "$LOG_FILE"
    
    # Asegurar que docs está actualizado
    if [ -d "$BASE/06-MONITOR/V3" ]; then
        cp -r "$BASE/06-MONITOR/V3/"* "$BASE/docs/" 2>/dev/null
        echo "Monitor copiado desde 06-MONITOR/V3" | tee -a "$LOG_FILE"
    fi
    
    # Migrar cambios
    migrar_github
}

# Menú de opciones
if [ "$1" = "unificar" ]; then
    unificar_estructura
elif [ "$1" = "configurar" ]; then
    configurar_pages
elif [ "$1" = "migrar" ]; then
    migrar_github
elif [ "$1" = "publicar" ]; then
    publicar_monitor
elif [ "$1" = "todo" ]; then
    unificar_estructura
    configurar_pages
    publicar_monitor
else
    echo "Uso: $0 {unificar|configurar|migrar|publicar|todo}"
    echo "  unificar   - Unificar estructura del sistema"
    echo "  configurar - Configurar GitHub Pages"
    echo "  migrar     - Subir cambios a GitHub"
    echo "  publicar   - Publicar monitor (copia + migra)"
    echo "  todo       - Ejecutar todo en orden"
fi

echo "" | tee -a "$LOG_FILE"
echo "=== OPERACIÓN COMPLETADA ===" | tee -a "$LOG_FILE"
echo "Log guardado en: $LOG_FILE" | tee -a "$LOG_FILE"

# ============================================================
# PIE DE PÁGINA INSTITUCIONAL
# Scripts fusionados:
# - SNX-PUBLISH-MONITOR.sh
# - snx_migracion_github_v1.sh
# - snx_pages_config_v1.sh
# - snx_unificador_soberano_v1.sh
# ============================================================
