#!/data/data/com.termux/files/usr/bin/bash
# SODA-NEXUS — AUDITORÍA PROFUNDA DE /docs V1
# Nada se borra. Todo se clasifica. Todo se documenta.

set -u

BASE="$HOME/soda/docs"
LOG="$HOME/soda/04-REGISTROS/SYSTEM/auditoria_docs_$(date +%Y%m%d_%H%M%S).log"

mkdir -p "$(dirname "$LOG")"

log() {
  echo -e "$1"
  echo -e "$1" >> "$LOG"
}

sep() {
  log "\n============================================================"
}

log "=== SNX — AUDITORÍA PROFUNDA DE /docs V1 ==="
log "Fecha: $(date)"
sep

###############################################
# 1. LISTADO COMPLETO DE ARCHIVOS
###############################################
log "🔍 [1] Listado completo de archivos en /docs..."
find "$BASE" -type f | tee -a "$LOG"

sep

###############################################
# 2. DETECCIÓN DE DUPLICADOS POR NOMBRE
###############################################
log "🔍 [2] Duplicados por nombre..."
find "$BASE" -type f -printf "%f\n" | sort | uniq -d | tee -a "$LOG"

sep

###############################################
# 3. DETECCIÓN DE ARCHIVOS SOSPECHOSOS PARA GITHUB PAGES
###############################################
log "🔍 [3] Archivos sospechosos para GitHub Pages..."
find "$BASE" -type f `\( \
  -name "*.py" -o \
  -name "*.sh" -o \
  -name "*.pem" -o \
  -name "*.yml" -o \
  -name "*.yaml" -o \
  -name "*.txt" -o \
  -name "*.md" \
\)` | tee -a "$LOG"

sep

###############################################
# 4. DETECCIÓN DE ARCHIVOS QUE ACTIVAN JEKYLL
###############################################
log "🔍 [4] Archivos que podrían activar Jekyll..."
find "$BASE" -type f -name "_*" | tee -a "$LOG"

sep

###############################################
# 5. DETECCIÓN DE ARCHIVOS GRANDES
###############################################
log "🔍 [5] Archivos mayores a 1MB..."
find "$BASE" -type f -size +1M | tee -a "$LOG"

sep

###############################################
# 6. DETECCIÓN DE ARCHIVOS CON BOM UTF-8
###############################################
log "🔍 [6] Archivos con BOM UTF-8..."
for f in $(find "$BASE" -type f); do
  if head -c 3 "$f" | grep -q $'\xEF\xBB\xBF'; then
    log "⚠️ BOM detectado: $f"
  fi
done

sep

###############################################
# 7. DETECCIÓN DE ARCHIVOS CON PERMISOS INCORRECTOS
###############################################
log "🔍 [7] Archivos con permisos incorrectos..."
find "$BASE" -type f ! -perm 644 -exec ls -l {} \; | tee -a "$LOG"

sep

###############################################
# 8. DETECCIÓN DE ARCHIVOS CON RUTAS PROFUNDAS
###############################################
log "🔍 [8] Archivos con rutas profundas..."
find "$BASE" -type f -printf "%d %p\n" | awk '$1 > 6 {print $2}' | tee -a "$LOG"

sep

###############################################
# 9. DETECCIÓN DE ARCHIVOS CON CARACTERES ESPECIALES
###############################################
log "🔍 [9] Archivos con caracteres especiales..."
find "$BASE" -type f | grep -E '[^A-Za-z0-9._/-]' | tee -a "$LOG"

sep

###############################################
# 10. RESUMEN FINAL
###############################################
log "📋 RESUMEN FINAL DE AUDITORÍA /docs"
log "✔ Archivos listados"
log "✔ Duplicados detectados"
log "✔ Archivos sospechosos detectados"
log "✔ Archivos que activan Jekyll detectados"
log "✔ Archivos grandes detectados"
log "✔ Archivos con BOM detectados"
log "✔ Permisos incorrectos detectados"
log "✔ Rutas profundas detectadas"
log "✔ Caracteres especiales detectados"
log "📄 Log completo: $LOG"

sep

log "=== PIE DE PÁGINA SOBERANO — CONTEXTUALIZACIÓN ACTIVA ==="
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
log "14. El Director decide; la IA ejecuta."
log "15. Reporte Antes/Después."
log "16. Prioridad: evitar Signal 9."
log "17. Nada se asume; todo se verifica."
log "18. IA evita antiamnesia."
log "19. GitHub es la Fuente de Verdad."
log "20. Scripts los modifica la IA."
log "21. No se pregunta; se trabaja."
