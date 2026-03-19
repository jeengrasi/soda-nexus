#!/bin/bash

echo "Ingrese su token de GitHub:"
read -s TOKEN

echo "Ingrese su usuario de GitHub:"
read USER

echo "Ingrese el nombre del repositorio del monitor:"
read REPO

VAULT="$HOME/soda/00-GOBIERNO/VAULT/github.env"

cat > "$VAULT" << EOL
GITHUB_USER="$USER"
GITHUB_REPO="$REPO"
GITHUB_TOKEN="$TOKEN"
EOL

chmod 600 "$VAULT"

echo "Token guardado de forma segura en VAULT."
