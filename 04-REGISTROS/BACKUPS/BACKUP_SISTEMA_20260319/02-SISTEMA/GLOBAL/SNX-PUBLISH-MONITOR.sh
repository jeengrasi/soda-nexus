#!/data/data/com.termux/files/usr/bin/bash

VAULT="$HOME/soda/00-GOBIERNO/VAULT/github.env"
MONITOR_DIR="$HOME/soda/03-OPERACIONES/WEB/monitor"
WORKDIR="$HOME/soda/99-TMP/snx_publish_monitor"

if [ ! -f "$VAULT" ]; then
    echo "❌ No se encontró github.env en la bóveda."
    exit 1
fi

GITHUB_USER=$(grep -oP '(?<=GITHUB_USER=).*' "$VAULT")
GITHUB_REPO=$(grep -oP '(?<=GITHUB_REPO=).*' "$VAULT")
GITHUB_TOKEN=$(grep -oP '(?<=GITHUB_TOKEN=).*' "$VAULT")

if [ -z "$GITHUB_USER" ] || [ -z "$GITHUB_REPO" ] || [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ github.env está incompleto."
    exit 1
fi

rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

echo "🔍 Clonando repositorio..."
git clone https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/$GITHUB_REPO.git repo

if [ ! -d "repo" ]; then
    echo "❌ No se pudo clonar el repositorio."
    exit 1
fi

cd repo

echo "📁 Preparando carpeta docs/"
rm -rf docs
mkdir docs

echo "📦 Copiando monitor..."
cp -r $MONITOR_DIR/* docs/

echo "📝 Commit y push..."
git add .
git commit -m "Publicación automática del monitor SODA-NEXUS"
git push

echo "🌐 Activando GitHub Pages..."
curl -X PUT \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/$GITHUB_USER/$GITHUB_REPO/pages \
  -d '{"source":{"branch":"main","path":"/docs"}}'

echo ""
echo "✔ Monitor publicado correctamente."
echo "🌍 URL pública:"
echo "https://$GITHUB_USER.github.io/$GITHUB_REPO/"
