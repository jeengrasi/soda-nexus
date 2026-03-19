#!/data/data/com.termux/files/usr/bin/bash
# SODA-NEXUS — CONFIGURACIÓN SOBERANA DE GITHUB PAGES V1

set -e

BASE="$HOME/soda"
LOG="$BASE/04-REGISTROS/SYSTEM/pages_config_$(date +%Y%m%d_%H%M%S).log"

log() {
  echo -e "$1"
  echo -e "$1" >> "$LOG"
}

log "=== SNX — CONFIGURACIÓN DE GITHUB PAGES V1 ==="
log "Fecha: $(date)"

# 1. Verificar si gh CLI está instalado
if ! command -v gh >/dev/null 2>&1; then
  log "❌ GitHub CLI no está instalado"
  exit 1
fi

# 2. Configurar Pages: branch master + carpeta docs
log "🔍 Configurando GitHub Pages..."
gh api \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  /repos/jeengrasi/soda-nexus/pages \
  -f source='{"branch":"master","path":"/docs"}' >> "$LOG" 2>&1

log "✔ GitHub Pages configurado correctamente"

# 3. Verificar publicación
sleep 10
URL="https://jeengrasi.github.io/soda-nexus/index.html"

STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$STATUS" = "200" ]; then
  log "✔ Monitor público disponible en: $URL"
else
  log "❌ Monitor aún no disponible. Código: $STATUS"
fi

log "📄 Log completo: $LOG"

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
