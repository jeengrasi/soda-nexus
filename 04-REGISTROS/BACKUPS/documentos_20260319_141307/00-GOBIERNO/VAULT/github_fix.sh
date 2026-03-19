#!/data/data/com.termux/files/usr/bin/bash

FILE="$HOME/soda/00-GOBIERNO/VAULT/github.env"

# Eliminar comillas dobles
sed -i 's/"//g' "$FILE"

chmod 600 "$FILE"

echo "✔ github.env corregido (comillas eliminadas)."
