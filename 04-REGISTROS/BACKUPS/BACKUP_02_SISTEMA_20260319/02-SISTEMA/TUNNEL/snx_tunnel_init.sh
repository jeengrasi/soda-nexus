#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# SODA‑NEXUS — Módulo de inicialización del túnel Cloudflare
# Script institucional para crear y configurar el túnel seguro
# ============================================================

echo "=== SODA‑NEXUS | Inicialización del túnel Cloudflare ==="
echo ""

# ------------------------------------------------------------
# 1. Solicitar token de Cloudflare Tunnel
# ------------------------------------------------------------
read -p "Ingrese el token de Cloudflare Tunnel: " CF_TOKEN

if [ -z "$CF_TOKEN" ]; then
    echo "[ERROR] No se ingresó ningún token. Abortando."
    exit 1
fi

# ------------------------------------------------------------
# 2. Crear bóveda si no existe
# ------------------------------------------------------------
VAULT_DIR="/data/data/com.termux/files/home/soda/00-VAULT"
mkdir -p "$VAULT_DIR"

# ------------------------------------------------------------
# 3. Guardar token en bóveda
# ------------------------------------------------------------
echo "CF_TUNNEL_TOKEN=\"$CF_TOKEN\"" > "$VAULT_DIR/tunnel.env"
chmod 600 "$VAULT_DIR/tunnel.env"

echo "[OK] Token almacenado en bóveda con permisos seguros."
echo ""

# ------------------------------------------------------------
# 4. Crear túnel con cloudflared
# ------------------------------------------------------------
echo "[INFO] Creando túnel 'soda-nexus'..."
cloudflared tunnel create soda-nexus

# ------------------------------------------------------------
# 5. Crear archivo de configuración
# ------------------------------------------------------------
CONFIG_DIR="/data/data/com.termux/files/home/soda/03-CONFIG/tunnel"
mkdir -p "$CONFIG_DIR"

cat > "$CONFIG_DIR/config.yml"

cat > ~/soda/02-SCRIPTS/TUNNEL/snx_tunnel_init.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# SODA‑NEXUS — Módulo de inicialización del túnel Cloudflare
# Script institucional para crear y configurar el túnel seguro
# ============================================================

echo "=== SODA‑NEXUS | Inicialización del túnel Cloudflare ==="
echo ""

# ------------------------------------------------------------
# 1. Solicitar token de Cloudflare Tunnel
# ------------------------------------------------------------
read -p "Ingrese el token de Cloudflare Tunnel: " CF_TOKEN

if [ -z "$CF_TOKEN" ]; then
    echo "[ERROR] No se ingresó ningún token. Abortando."
    exit 1
fi

# ------------------------------------------------------------
# 2. Crear bóveda si no existe
# ------------------------------------------------------------
VAULT_DIR="/data/data/com.termux/files/home/soda/00-VAULT"
mkdir -p "$VAULT_DIR"

# ------------------------------------------------------------
# 3. Guardar token en bóveda
# ------------------------------------------------------------
echo "CF_TUNNEL_TOKEN=\"$CF_TOKEN\"" > "$VAULT_DIR/tunnel.env"
chmod 600 "$VAULT_DIR/tunnel.env"

echo "[OK] Token almacenado en bóveda con permisos seguros."
echo ""

# ------------------------------------------------------------
# 4. Crear túnel con cloudflared
# ------------------------------------------------------------
echo "[INFO] Creando túnel 'soda-nexus'..."
cloudflared tunnel create soda-nexus

# ------------------------------------------------------------
# 5. Crear archivo de configuración
# ------------------------------------------------------------
CONFIG_DIR="/data/data/com.termux/files/home/soda/03-CONFIG/tunnel"
mkdir -p "$CONFIG_DIR"

cat > "$CONFIG_DIR/config.yml" <<EOF2
tunnel: soda-nexus
credentials-file: /data/data/com.termux/files/home/.cloudflared/soda-nexus.json

ingress:
  - hostname: nexus.cloudflareaccess.com
    service: http://localhost:5173
  - hostname: monitor.cloudflareaccess.com
    service: http://localhost:5050
  - service: http_status:404
EOF2

echo "[OK] Archivo de configuración generado."
echo ""

# ------------------------------------------------------------
# 6. Ejecutar túnel
# ------------------------------------------------------------
echo "[INFO] Iniciando túnel..."
cloudflared tunnel run soda-nexus --config "$CONFIG_DIR/config.yml"

# ============================================================
# OBSERVACIONES
# ------------------------------------------------------------
# - Este script solicita el token al usuario y lo guarda en la
#   bóveda institucional con permisos 600.
# - El token nunca queda expuesto en texto plano fuera de Termux.
# - El túnel 'soda-nexus' se crea de forma segura y auditable.
# - La configuración define dos hostnames:
#       nexus.cloudflareaccess.com  → WebApp (5173)
#       monitor.cloudflareaccess.com → Backend (5050)
# - El túnel queda listo para integrarse con Telegram WebApp.
# ============================================================

# FOOTER INSTITUCIONAL
# SODA‑NEXUS | Sistema soberano | Anti‑amnesia | Auditabilidad total
# ============================================================
