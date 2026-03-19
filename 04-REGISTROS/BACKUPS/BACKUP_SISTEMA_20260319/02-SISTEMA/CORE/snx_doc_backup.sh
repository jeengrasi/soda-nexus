#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# [OBS 00] TITULO:
#          Backup documental soberano del Estado SODA‑NEXUS.
#          PROPOSITO:
#            - Crear un respaldo completo de la memoria institucional.
#          POR QUE EXISTE:
#            - Garantizar continuidad ante fallos, migraciones o auditorías.
#          RIESGOS CRITICOS:
#            - Si no se realizan backups, se pierde historia institucional.
#          DEPENDENCIAS:
#            - Estructura de carpetas 01-MEMORIA, 02-SISTEMA, 03-OPERACIONES.
#          MEMORIA HISTORICA:
#            - Creado durante la consolidación documental 2026.
#          LINEAS AFECTADAS:
#            - No modifica nada; solo genera un archivo .tar.gz
#          AUTORIA:
#            - Copilot + Director Jeisson — 2026-02-24
# ============================================================

BASE="$HOME/soda"
OUTDIR="$BASE/backups"
mkdir -p "$OUTDIR"

OUTFILE="$OUTDIR/snx_backup_$(date +%Y%m%d_%H%M).tar.gz"

echo "=== SNX-DOC: Creando backup documental ==="

tar -czf "$OUTFILE" \
  "$BASE/01-MEMORIA" \
  "$BASE/02-SISTEMA" \
  "$BASE/03-OPERACIONES" \
  "$BASE/05-REGISTROS"

echo "=== SNX-DOC: Backup generado ==="
echo "Archivo: $OUTFILE"

# ============================================================
# PIE DE PAGINA INSTITUCIONAL SODA-NEXUS - SNX-DOC-STD-v3.0
# ============================================================
# IDENTIDAD:
#   - Documento: 02-SISTEMA/CORE/snx_doc_backup.sh
#   - Version: 1.0.0
#   - Rol institucional: Backup documental soberano
#
# MEMORIA:
#   - Creado para garantizar continuidad institucional.
#
# ANTIAMNESIA:
#   - Ejecutar antes de migraciones o cambios mayores.
#
# INTEGRIDAD:
#   - Hash SHA-256: [pendiente]
#
# GOBERNANZA:
#   - Autor original: Copilot
#   - Ratificado por: Director Jeisson
#
# RECORDATORIO:
#   - Termux es la raíz del Estado SODA-NEXUS.
# ============================================================
