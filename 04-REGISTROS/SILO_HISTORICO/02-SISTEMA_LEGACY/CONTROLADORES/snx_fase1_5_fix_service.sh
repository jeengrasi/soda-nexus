#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX-F1.5 — Corrección del servicio permanente de blindaje
# SODA-NEXUS — Fase 1.5
# No borra nada. No modifica nada existente.
# Solo corrige la instalación del servicio snx_termux_blindaje.
# ============================================================================

SODA="$HOME/soda"
SERVICIO_DIR="$PREFIX/var/service/snx_termux_blindaje"
SCRIPT="$SODA/02-SISTEMA/SERVICIOS/snx_termux_blindaje.sh"
REGISTROS="$SODA/05-REGISTROS/GUARDIAN/SESIONES"

mkdir -p "$REGISTROS"

timestamp() { date +"%Y-%m-%d %H:%M:%S"; }
log() {
    echo "[$(timestamp)] $1" >> "$REGISTROS/snx_fase1_5_fix_service_$(date +"%Y%m%d").log"
}

log "Iniciando Fase 1.5 — Corrección del servicio permanente."

# 1. Verificar termux-services
if ! command -v sv-enable >/dev/null 2>&1; then
    log "termux-services no encontrado. Instalando..."
    pkg install -y termux-services
    log "termux-services instalado."
else
    log "termux-services ya está instalado."
fi

# 2. Crear carpeta del servicio
mkdir -p "$SERVICIO_DIR"

# 3. Crear archivo run
cat > "$SERVICIO_DIR/run" << RUNEOF
#!/data/data/com.termux/files/usr/bin/bash
exec "$SCRIPT"
RUNEOF

chmod +x "$SERVICIO_DIR/run"
log "Archivo run creado y marcado como ejecutable."

# 4. Activar servicio
sv-enable snx_termux_blindaje 2>/dev/null
sleep 1

# 5. Verificar supervise
if [ -d "$SERVICIO_DIR/supervise" ]; then
    log "Servicio iniciado correctamente. supervise/ detectado."
else
    log "ADVERTENCIA: supervise/ no detectado. Forzando arranque..."
    sv up snx_termux_blindaje 2>/dev/null
    sleep 2
fi

if [ -d "$SERVICIO_DIR/supervise" ]; then
    log "supervise/ creado exitosamente."
else
    log "ERROR: supervise/ aún no existe. Requiere revisión manual."
fi

log "Fase 1.5 completada."
# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL
# Esta fase corrige la instalación del servicio sin alterar componentes previos.
# Mantiene la soberanía, auditabilidad y continuidad del blindaje.
# ============================================================================
