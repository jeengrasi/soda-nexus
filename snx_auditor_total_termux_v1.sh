#!/data/data/com.termux/files/usr/bin/bash
# SODA-NEXUS — AUDITORÍA TOTAL DE TERMUX V1
# Procesos + Archivos + Estructura + Versiones + Duplicados + Huérfanos

set -u

BASE="$HOME/soda"
LOG="$BASE/04-REGISTROS/SYSTEM/auditoria_total_termux_$(date +%Y%m%d_%H%M%S).log"
mkdir -p "$BASE/04-REGISTROS/SYSTEM"

log() {
  echo -e "$1"
  echo -e "$1" >> "$LOG"
}

sep() {
  log "\n============================================================"
}

log "=== AUDITORÍA TOTAL DE TERMUX — SODA-NEXUS V1 ==="
log "Fecha: $(date)"
sep

############################
# 1. PROCESOS ACTIVOS
############################
log "🔍 [1] Procesos activos en Termux..."
ps aux | tee -a "$LOG"

sep

############################
# 2. PUERTOS ACTIVOS
############################
log "🔍 [2] Puertos activos..."
lsof -i -P -n | tee -a "$LOG"

sep

############################
# 3. ESTRUCTURA COMPLETA DE SODA
############################
log "🔍 [3] Estructura completa de ~/soda..."
find "$BASE" -maxdepth 6 -type f -not -path "*/.git/*" | tee -a "$LOG"

sep

############################
# 4. DETECCIÓN DE MONITORES
############################
log "🔍 [4] Detectando monitores (index*.html)..."
find "$BASE" -type f -name "index*.html" -not -path "*/.git/*" | tee -a "$LOG"

sep

############################
# 5. DETECCIÓN DE JSON
############################
log "🔍 [5] Detectando JSON..."
find "$BASE" -type f -name "*.json" -not -path "*/.git/*" | tee -a "$LOG"

sep

############################
# 6. DETECCIÓN DE JS
############################
log "🔍 [6] Detectando JS..."
find "$BASE" -type f -name "*.js" -not -path "*/.git/*" | tee -a "$LOG"

sep

############################
# 7. DETECCIÓN DE CSS
############################
log "🔍 [7] Detectando CSS..."
find "$BASE" -type f -name "*.css" -not -path "*/.git/*" | tee -a "$LOG"

sep

############################
# 8. DETECCIÓN DE ARCHIVOS HUÉRFANOS
############################
log "🔍 [8] Detectando archivos huérfanos..."
find "$BASE" -maxdepth 6 -type f -not -path "*/.git/*" \
  | grep -v "00-GOBIERNO" \
  | grep -v "01-MEMORIA" \
  | grep -v "02-SISTEMA" \
  | grep -v "03-OPERACIONES" \
  | grep -v "04-REGISTROS" \
  | grep -v "05-DOCUMENTACION" \
  | grep -v "06-MONITOR" \
  | tee -a "$LOG"

sep

############################
# 9. DETECCIÓN DE DUPLICADOS
############################
log "🔍 [9] Detectando duplicados..."
find "$BASE" -type f -not -path "*/.git/*" -printf "%f\n" \
  | sort | uniq -d | tee -a "$LOG"

sep

############################
# 10. RESUMEN FINAL
############################
log "📋 RESUMEN FINAL DE AUDITORÍA TOTAL"
log "✔ Procesos auditados"
log "✔ Puertos auditados"
log "✔ Archivos auditados"
log "✔ Monitores detectados"
log "✔ JSON detectados"
log "✔ JS detectados"
log "✔ CSS detectados"
log "✔ Huérfanos detectados"
log "✔ Duplicados detectados"
log "📄 Reporte completo: $LOG"

sep

log "=== PIE DE PÁGINA SOBERANO ==="
log "1. Nada se borra, todo es útil."
log "2. Termux es la memoria y la verdad."
log "3. Validar scripts antes de modificar."
log "4. Sistema ligero pero potente."
log "5. Todo auditado y certificado."
log "6. Consultar Termux antes de actuar."
log "7. Todo es real."
log "8. Varias tareas por chat."
log "9. Identidad: jeengrasi/soda-nexus."
log "10. Escudo GitHub activo."
log "11. GitHub cerebro, Termux puente."
log "12. ADN en Vault, resto en nube."
log "13. Investigación obligatoria."
log "14. Director decide; IA ejecuta."
log "15. Reporte Antes/Después."
log "16. Prioridad: evitar Signal 9."
log "17. Nada se asume; todo se verifica."
log "18. IA evita antiamnesia."
log "19. GitHub es la Fuente de Verdad."
log "20. Scripts los modifica la IA."
log "21. No se pregunta; se trabaja."
