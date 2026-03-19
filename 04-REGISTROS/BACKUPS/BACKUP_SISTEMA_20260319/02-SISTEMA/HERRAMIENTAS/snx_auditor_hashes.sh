#!/data/data/com.termux/files/usr/bin/bash
# SNX - AUDITOR DE INTEGRIDAD LIGERO
HASH_DIR="$HOME/soda/01-MEMORIA/ACTUAL/HASHES"
echo "[$(date)] Iniciando verificación de integridad..."
find "$HASH_DIR" -type f -name "*.sha" -exec sha256sum -c {} \; 2>/dev/null
