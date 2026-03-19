#!/data/data/com.termux/files/usr/bin/bash
# SODA-NEXUS — AUDITORÍA SOBERANA DEL MONITOR V7
# Rol: Auditor, Notario, Contralor, Veedor y Abogado del Monitor

set -u  # No usamos -e para no abortar la auditoría ante el primer fallo

BASE_DIR="$HOME/soda"
API_DIR="$BASE_DIR/02-SISTEMA/API"
MONITOR_DIR="$BASE_DIR/06-MONITOR"
LOG_DIR="$BASE_DIR/04-REGISTROS/SYSTEM"
mkdir -p "$LOG_DIR"

REPORTE="$LOG_DIR/auditoria_monitor_$(date +%Y%m%d_%H%M%S).log"

log() {
  echo -e "$1"
  echo -e "$1" >> "$REPORTE"
}

sep() {
  log "\n============================================================"
}

log "=== AUDITORÍA SOBERANA DEL MONITOR SODA-NEXUS V7 ==="
log "Fecha: $(date)"
log "Base: $BASE_DIR"
sep

############################
# 1. VERIFICACIÓN DE ESTRUCTURA
############################
log "🔍 [1] Verificación de estructura de ministerios en Termux..."

for d in 00-GOBIERNO 01-MEMORIA 02-SISTEMA 03-OPERACIONES 04-REGISTROS 05-DOCUMENTACION 06-MONITOR; do
  if [ -d "$BASE_DIR/$d" ]; then
    log "✅ Ministerio presente: $d"
  else
    log "⚠️ Ministerio AUSENTE en Termux: $d (puede estar solo en GitHub, verificar diseño híbrido)"
  fi
done

sep

############################
# 2. DETECCIÓN DEL MONITOR REAL
############################
log "🔍 [2] Búsqueda de archivos del monitor (index-v*.html, monitor_data.json)..."

find "$BASE_DIR" -maxdepth 6 -type f `\( -name "index-v*.html" -o -name "index.html" -o -name "monitor_data.json" \)` 2>/dev/null | tee -a "$REPORTE"

INDEX_HTML=$(find "$BASE_DIR" -maxdepth 6 -type f -name "index-v*.html" 2>/dev/null | head -n 1 || true)
MONITOR_DATA=$(find "$BASE_DIR" -maxdepth 6 -type f -name "monitor_data.json" 2>/dev/null | head -n 1 || true)

if [ -n "${INDEX_HTML:-}" ]; then
  log "✅ HTML del monitor detectado: $INDEX_HTML"
else
  log "❌ No se encontró ningún index-v*.html en Termux."
fi

if [ -n "${MONITOR_DATA:-}" ]; then
  log "✅ monitor_data.json detectado: $MONITOR_DATA"
else
  log "❌ No se encontró monitor_data.json en Termux."
fi

sep

############################
# 3. DEPENDENCIAS CRÍTICAS
############################
log "🔍 [3] Verificación de dependencias Python (flask, flask_cors, waitress)..."

python - << 'PYEOF' 2>>"$REPORTE"
import importlib

mods = ["flask", "flask_cors", "waitress"]
for m in mods:
    try:
        importlib.import_module(m)
        print(f"✅ Módulo disponible: {m}")
    except Exception as e:
        print(f"❌ Módulo FALTANTE: {m} -> {e}")
PYEOF

sep

############################
# 4. PROCESOS Y PUERTOS
############################
log "🔍 [4] Inspección de procesos y puertos (15051, 18080)..."

for p in 15051 18080; do
  log "\n--- Puerto $p ---"
  lsof -i:"$p" 2>/dev/null | tee -a "$REPORTE" || log "⚠️ lsof no devolvió resultados para el puerto $p."
done

log "\n🔍 Procesos Python relevantes:"
ps aux | grep -E "api_|waitress|gunicorn|flask" | grep -v grep | tee -a "$REPORTE"

sep

############################
# 5. PRUEBAS DE ACCESO LOCAL (CURL)
############################
log "🔍 [5] Pruebas de acceso HTTP local (localhost)..."

for p in 15051 18080; do
  log "\n--- CURL a puerto $p ---"
  curl -s -o /dev/null -w "Código HTTP: %{http_code}\n" "http://127.0.0.1:$p/" 2>>"$REPORTE" || log "❌ Error al conectar con http://127.0.0.1:$p/"
  curl -s -o /dev/null -w "Código HTTP /api/data: %{http_code}\n" "http://127.0.0.1:$p/api/data" 2>>"$REPORTE" || log "❌ Error al conectar con /api/data en puerto $p"
done

sep

############################
# 6. VALIDACIÓN DE API_WAITRESS.PY
############################
log "🔍 [6] Validación de api_waitress.py (si existe)..."

if [ -f "$API_DIR/api_waitress.py" ]; then
  log "✅ api_waitress.py encontrado en $API_DIR"
  log "🔎 Prueba de compilación de sintaxis..."
  if python -m py_compile "$API_DIR/api_waitress.py" 2>>"$REPORTE"; then
    log "✅ Sintaxis de api_waitress.py correcta."
  else
    log "❌ Error de sintaxis en api_waitress.py (ver reporte)."
  fi
else
  log "⚠️ api_waitress.py NO encontrado en $API_DIR"
fi

sep

############################
# 7. RESUMEN EJECUTIVO
############################
log "📋 RESUMEN EJECUTIVO DE LA AUDITORÍA"

if [ -n "${INDEX_HTML:-}" ] && [ -n "${MONITOR_DATA:-}" ]; then
  log "✅ El monitor tiene HTML y JSON detectables en Termux."
else
  log "❌ Faltan piezas clave del monitor (HTML o JSON)."
fi

log "📄 Reporte completo guardado en: $REPORTE"
log "Director, la auditoría ha concluido. Revise el reporte para ver aciertos y errores detallados."
