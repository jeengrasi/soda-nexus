#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — FASE 5.7.2
# Reparación total de ~/.bashrc (archivo corrupto por fi suelto)
# ============================================================================
BASHRC="$HOME/.bashrc"
BACKUP="$HOME/.bashrc.bak_reparacion_$(date +%Y%m%d-%H%M%S)"

echo "[SNX] Creando backup de ~/.bashrc en: $BACKUP"
cp "$BASHRC" "$BACKUP"

echo "[SNX] Generando ~/.bashrc limpio y seguro..."

cat > "$BASHRC" << 'EOF_BASHRC'
# ============================================================================
# ~/.bashrc — Archivo limpio, seguro y compatible con Termux
# SODA-NEXUS — No modificar a mano
# ============================================================================

# Habilitar colores básicos
export TERMUX_PS1="yes"

# Alias útiles
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# PATH estándar de Termux
export PATH=$PATH:$HOME/bin

# ============================================================================
# FIN — ~/.bashrc limpio
# ============================================================================
EOF_BASHRC

echo "[SNX] Validando sintaxis..."
bash -n "$BASHRC"
if [ $? -ne 0 ]; then
    echo "[ERROR] El nuevo ~/.bashrc tiene errores. Restaurando backup..."
    cp "$BACKUP" "$BASHRC"
    exit 1
fi

echo "[SNX] ~/.bashrc reparado exitosamente."
echo "[SNX] FASE 5.7.2 COMPLETADA."
# ============================================================================
# PIE INSTITUCIONAL
# ============================================================================
