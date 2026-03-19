#!/data/data/com.termux/files/usr/bin/bash

VAULT_DIR="$HOME/soda/02-SISTEMA/VAULT"
URL_FILE="$VAULT_DIR/REMOTE_IA_URL"
MODEL_FILE="$VAULT_DIR/REMOTE_IA_MODEL"
KEY_FILE="$VAULT_DIR/REMOTE_IA_KEY"

mkdir -p "$VAULT_DIR"

echo "==============================================="
echo " REGISTRO DE IA REMOTA — SODA-NEXUS"
echo "==============================================="
echo
echo "Ejemplo de URL (servidor propio compatible chat/completions):"
echo "  http://192.168.1.100:11434/v1/chat/completions"
echo

read -p "URL del endpoint remoto: " URL
if [ -z "$URL" ]; then
  echo "URL vacía. No se guardó nada."
  exit 1
fi

read -p "Nombre del modelo remoto: " MODEL
if [ -z "$MODEL" ]; then
  echo "Modelo vacío. No se guardó nada."
  exit 1
fi

read -p "Clave (opcional, ENTER si no usa): " KEY

echo -n "$URL" > "$URL_FILE"
echo -n "$MODEL" > "$MODEL_FILE"
chmod 600 "$URL_FILE"
chmod 644 "$MODEL_FILE"

if [ -n "$KEY" ]; then
  echo -n "$KEY" > "$KEY_FILE"
  chmod 400 "$KEY_FILE"
  echo
  echo "Clave remota guardada en:"
  echo "  $KEY_FILE"
fi

echo
echo "IA remota registrada:"
echo "  URL:   $URL_FILE"
echo "  Modelo:$MODEL_FILE"
echo
