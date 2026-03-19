#!/data/data/com.termux/files/usr/bin/bash
set -e

BASE="$HOME/soda"
VAULT="$BASE/02-SISTEMA/VAULT"
REG_SYS="$BASE/04-REGISTROS/SYSTEM"
mkdir -p "$REG_SYS" "$VAULT"

TS="$(date +%Y%m%d_%H%M%S)"
LOG_FIX="$REG_SYS/fix_ia_vaults_v1_$TS.log"

echo "==========================================" | tee -a "$LOG_FIX"
echo "[FIX IA VAULTS V1] $TS" | tee -a "$LOG_FIX"
echo "VAULT: $VAULT" | tee -a "$LOG_FIX"
echo "==========================================" | tee -a "$LOG_FIX"

ensure_file() {
  local path="$1"
  local default="$2"
  if [ -f "$path" ]; then
    echo "[OK] existe: $path" | tee -a "$LOG_FIX"
  else
    echo "$default" > "$path"
    echo "[CREADO] $path" | tee -a "$LOG_FIX"
  fi
}

# Modelo local (placeholder, no ejecuta nada por sí solo)
ensure_file "$VAULT/LOCAL_IA_MODEL" "ollama:llama3"

# IA remota (placeholder DeepSeek, ajustable luego)
ensure_file "$VAULT/REMOTE_IA_URL" "https://api.deepseek.com/chat/completions"
ensure_file "$VAULT/REMOTE_IA_MODEL" "deepseek-chat"

# Clave remota: si existe DEEPSEEK_KEY, la copiamos
if [ -f "$VAULT/DEEPSEEK_KEY" ] && [ ! -f "$VAULT/REMOTE_IA_KEY" ]; then
  cp "$VAULT/DEEPSEEK_KEY" "$VAULT/REMOTE_IA_KEY"
  echo "[COPIA] DEEPSEEK_KEY -> REMOTE_IA_KEY" | tee -a "$LOG_FIX"
else
  ensure_file "$VAULT/REMOTE_IA_KEY" ""
fi

echo "==========================================" | tee -a "$LOG_FIX"
echo "[FIX IA VAULTS V1 COMPLETADO] Log: $LOG_FIX" | tee -a "$LOG_FIX"
echo "==========================================" | tee -a "$LOG_FIX"
