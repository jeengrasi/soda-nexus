#!/usr/bin/env bash

echo "=== SODA-NEXUS :: SELECCIÓN AUTOMÁTICA DE REPOSITORIO ==="
echo ""

TMPFILE=$(mktemp)

i=1
find ~ -type d -name ".git" 2>/dev/null | while read gitdir; do
    repo_dir=$(dirname "$gitdir")
    echo "$i) $repo_dir"
    echo "$repo_dir" >> "$TMPFILE"
    i=$((i+1))
done

echo ""
read -p "Selecciona el número del repositorio correcto: " choice

repo=$(sed -n "${choice}p" "$TMPFILE")
rm "$TMPFILE"

if [ -z "$repo" ]; then
    echo "Selección inválida."
    exit 1
fi

echo "$repo" > ~/soda/02-SISTEMA/BACKEND/MONITOR/REPO_PATH.txt

echo "Repositorio seleccionado:"
echo "$repo"
echo "Guardado en REPO_PATH.txt"
