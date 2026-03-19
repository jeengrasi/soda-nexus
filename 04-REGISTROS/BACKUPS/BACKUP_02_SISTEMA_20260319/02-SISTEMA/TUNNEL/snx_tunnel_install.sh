#!/data/data/com.termux/files/usr/bin/bash
# ---------------------------------------------------------
# SODA‑NEXUS — Instalación del túnel Cloudflare
# ---------------------------------------------------------
# Observación:
# Este script solicita el token del túnel, lo guarda en VAULT
# y ejecuta la instalación sin exponer el token en pantalla.
# ---------------------------------------------------------

VAULT_DIR="$HOME/soda/00-GOBIERNO/VAULT"
TOKEN_FILE="$VAULT_DIR/cloudflare_tunnel.token"

mkdir -p "$VAULT_DIR"

echo "Ingrese el token del túnel Cloudflare:"
read -s CF_TOKEN

echo "$CF_TOKEN" > "$TOKEN_FILE"
chmod 600 "$TOKEN_FILE"

echo "Instalando túnel con token almacenado..."
cloudflared service install "$CF_TOKEN"

echo "Túnel instalado. Token guardado en VAULT."
echo "Listo para continuar con la configuración del hostname."
# ---------------------------------------------------------
# Regla institucional #11:
# Los tokens, archivos y configuraciones históricas en VAULT
# forman parte del presente institucional. No deben eliminarse
# ni ignorarse mientras sean funcionales. Si dejan de serlo,
# se conservan como memoria histórica y se reemplazan solo
# mediante adición, nunca sustitución.
# ---------------------------------------------------------
