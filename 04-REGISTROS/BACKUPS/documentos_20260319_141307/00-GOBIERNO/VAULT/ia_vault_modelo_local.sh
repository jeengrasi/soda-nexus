#!/data/data/com.termux/files/usr/bin/bash

VAULT_DIR="$HOME/soda/02-SISTEMA/VAULT"
VAULT_FILE="$VAULT_DIR/LOCAL_IA_MODEL"

mkdir -p "$VAULT_DIR"

echo "==============================================="
echo " REGISTRO DE MODELO IA LOCAL — SODA-NEXUS"
echo "==============================================="
echo
echo "Ejemplos de modelo (servidor tipo Ollama/llama.cpp compatible):"
echo "  phi3:mini"
echo "  qwen2.5:1.5b"
echo "  tinyllama"
echo

read -p "Nombre del modelo local: " MODEL

if [ -z "$MODEL" ]; then
  echo "Modelo vacío. No se guardó nada."
  exit 1
fi

echo -n "$MODEL" > "$VAULT_FILE"
chmod 644 "$VAULT_FILE"

echo
echo "Modelo local guardado en:"
echo "  $VAULT_FILE"
echo "Permisos: 644"
echo
