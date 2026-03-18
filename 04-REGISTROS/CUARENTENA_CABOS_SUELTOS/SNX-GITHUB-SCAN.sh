#!/data/data/com.termux/files/usr/bin/bash

# Ruta real de la bóveda institucional
VAULT_FILE="$HOME/soda/00-GOBIERNO/VAULT/github.env"

if [ ! -f "$VAULT_FILE" ]; then
    echo "❌ No se encontró github.env en la bóveda institucional."
    exit 1
fi

# Cargar token sin exponerlo
GITHUB_TOKEN=$(grep -oP '(?<=TOKEN=).*' "$VAULT_FILE")

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ github.env existe pero no contiene TOKEN=..."
    exit 1
fi

echo "🔍 Consultando repositorios de GitHub..."

# Obtener lista de repositorios
REPOS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
    https://api.github.com/user/repos | grep '"full_name"' | cut -d '"' -f 4)

echo ""
echo "============================================"
echo "📁 LISTA DE REPOSITORIOS EN TU GITHUB"
echo "============================================"
echo ""

echo "$REPOS"

echo ""
echo "============================================"
echo "📂 ARCHIVOS EN CADA REPOSITORIO"
echo "============================================"
echo ""

for repo in $REPOS; do
    echo "🔸 Repositorio: $repo"
    CONTENTS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
        https://api.github.com/repos/$repo/contents/ | grep '"name"' | cut -d '"' -f 4)

    if [ -z "$CONTENTS" ]; then
        echo "   (vacío o privado sin permisos)"
    else
        echo "$CONTENTS" | sed 's/^/   - /'
    fi

    echo ""
done
