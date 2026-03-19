#!/data/data/com.termux/files/usr/bin/bash

VAULT_DIR="$HOME/soda/02-SISTEMA/VAULT"
VAULT_FILE="$VAULT_DIR/DEEPSEEK_KEY"

mkdir -p "$VAULT_DIR"

echo "==============================================="
echo " REGISTRO SOBERANO DE CLAVE DEEPSEEK — SODA"
echo "==============================================="
echo
echo "La clave se guardará en:"
echo "  $VAULT_FILE"
echo
echo "No se mostrará en pantalla después de guardarse."
echo

read -p "Pega tu API Key de DeepSeek y presiona ENTER: " KEY

if [ -z "$KEY" ]; then
  echo "Clave vacía. No se guardó nada."
  exit 1
fi

echo -n "$KEY" > "$VAULT_FILE"
chmod 600 "$VAULT_FILE"

echo
echo "Clave guardada y blindada en VAULT."
echo "Ubicación: $VAULT_FILE"
echo "Permisos: 600"
echo
