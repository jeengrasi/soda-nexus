#!/data/data/com.termux/files/usr/bin/bash

VAULT_FILE="$HOME/soda/00-GOBIERNO/VAULT/github.env"

if [ ! -f "$VAULT_FILE" ]; then
    echo "❌ No se encontró github.env"
    exit 1
fi

GITHUB_TOKEN=$(grep -oP '(?<=TOKEN=).*' "$VAULT_FILE")

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ TOKEN= está vacío"
    exit 1
fi

echo "🔍 Verificando tipo de token..."

# 1. Verificar si es fine-grained
FINE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user | grep '"permissions"')

if [ -n "$FINE" ]; then
    echo "✔ Token fine-grained detectado"
else
    echo "✔ Token classic detectado"
fi

echo ""
echo "🔍 Verificando permisos..."

# 2. Intentar leer metadata de repos
META=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user/repos?per_page=1)

if echo "$META" | grep -q '"full_name"'; then
    echo "✔ Permiso de lectura de repositorios: OK"
else
    echo "❌ Sin permiso de lectura de repositorios"
fi

# 3. Intentar leer usuario
USER=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user | grep '"login"')

if [ -n "$USER" ]; then
    echo "✔ Permiso de lectura de usuario: OK"
else
    echo "❌ El token no puede leer el usuario (posible revocación)"
fi

