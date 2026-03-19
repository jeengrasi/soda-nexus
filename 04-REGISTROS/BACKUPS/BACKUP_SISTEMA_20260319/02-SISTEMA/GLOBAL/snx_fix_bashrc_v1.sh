#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — FASE 5.7
# Corrección del entorno Termux: eliminar referencias a snx_check en ~/.bashrc
# ============================================================================

BASHRC="$HOME/.bashrc"
BACKUP="$HOME/.bashrc.bak_snxfix_$(date +%Y%m%d-%H%M%S)"
TEMP="$HOME/.bashrc.tmp_snxfix"

echo "[SNX] Creando backup de ~/.bashrc en: $BACKUP"
cp "$BASHRC" "$BACKUP"

echo "[SNX] Eliminando líneas corruptas que contienen 'snx_check'..."
grep -v "snx_check" "$BASHRC" > "$TEMP"

echo "[SNX] Reemplazando ~/.bashrc con versión corregida..."
mv "$TEMP" "$BASHRC"

echo "[SNX] Validando que no existan referencias a snx_check..."
if grep -q "snx_check" "$BASHRC"; then
    echo "[ERROR] La referencia sigue presente. Abortando."
    exit 1
fi

echo "[SNX] ~/.bashrc corregido exitosamente."
echo "[SNX] FASE 5.7 COMPLETADA."
# ============================================================================
# PIE INSTITUCIONAL
# Prohibido modificar ~/.bashrc a mano. Solo mediante scripts soberanos.
# ============================================================================
