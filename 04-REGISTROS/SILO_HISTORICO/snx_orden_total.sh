#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# SODA‑NEXUS — SCRIPT DE ORDEN TOTAL V1
# Propósito: Limpieza, consolidación y cumplimiento de Regla 8.
# ============================================================
BASE="$HOME/soda"
SILO="$HOME/soda_archive_seguridad"

echo "[$(date)] INICIANDO SANEAMIENTO DE ORDEN TOTAL"

# [OBS] Mover la carpeta 06-MONITOR (Ilegal según Regla 8) al SILO
if [ -d "$BASE/06-MONITOR" ]; then
    echo "📦 Consolidando 06-MONITOR en Silo de Seguridad..."
    mv "$BASE/06-MONITOR" "$SILO/06-MONITOR_$(date +%Y%m%d)"
fi

# [OBS] Mover archivos sueltos en la raíz de ~/soda/ al Silo
# Solo deben quedar las carpetas 00, 01, 02, 03, 04, 05.
find "$BASE" -maxdepth 1 -type f -exec mv {} "$SILO/" \;

# [OBS] Identificar y eliminar carpetas vacías dentro de los ministerios
# Esto aligera el sistema sin perder datos (porque están vacías).
find "$BASE" -type d -empty -delete

echo "✅ ORDEN TOTAL COMPLETADO. Sistema restringido a Ministerios 00-05."
# ============================================================
# PIE DE PÁGINA INSTITUCIONAL — SODA‑NEXUS
# ============================================================
