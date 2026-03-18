#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# SODA‑NEXUS — Login institucional para Cloudflare Tunnel
# ============================================================

echo "=== SODA‑NEXUS | Login de Cloudflare Tunnel ==="
echo ""

echo "[INFO] Iniciando proceso de login..."
echo "[INFO] Cloudflare abrirá una URL en pantalla."
echo "[INFO] Debe abrir esa URL en su navegador y aprobar el acceso."
echo ""

cloudflared tunnel login

echo ""
read -p "Presione ENTER cuando haya completado el login en el navegador... " ok

CERT_PATH="/data/data/com.termux/files/home/.cloudflared/cert.pem"

if [ ! -f "$CERT_PATH" ]; then
    echo "[ERROR] No se encontró cert.pem. El login no se completó."
    exit 1
fi

echo "[OK] Certificado encontrado: $CERT_PATH"
echo "[OK] Login completado correctamente."
echo ""

# ============================================================
# OBSERVACIONES
# ------------------------------------------------------------
# - Este script ejecuta el login obligatorio para Cloudflare.
# - El archivo cert.pem es requerido para crear túneles.
# - Sin este archivo, Cloudflare rechaza la creación del túnel.
# ============================================================

# FOOTER INSTITUCIONAL
# SODA‑NEXUS | Sistema soberano | Anti‑amnesia | Auditabilidad total
# ============================================================
