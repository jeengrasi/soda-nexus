#!/bin/bash
# ============================================================
# IA‑SCRIPT CENTRAL — SODA‑NEXUS v3.0
# Sistema inmune institucional
# Protector, verificador, auditor, certificador y restaurador
# ============================================================

BASE="$HOME/soda"
VAULT="$BASE/00-GOBIERNO/VAULT"
ESTADO="$BASE/00-GOBIERNO/ESTADO"
LOGS="$BASE/00-GOBIERNO/LOGS"
DERIVADOS="$BASE/02-SISTEMA/DERIVADOS"
META="$BASE/00-GOBIERNO/META"

CENTRAL="$BASE/02-SISTEMA/BACKEND/snx_ia_central.sh"
CENTRAL_META="$META/central.meta"
CENTRAL_BACKUP="$VAULT/central.backup"

mkdir -p "$LOGS" "$META"

LOGFILE="$LOGS/central.log"
STATEFILE="$ESTADO/snx_state.json"

timestamp() { date +"%Y-%m-%d %H:%M:%S"; }

log() {
  echo "$(timestamp) — $1" >> "$LOGFILE"
}

# ============================================================
# 0. AUTOPROTECCIÓN DEL IA‑SCRIPT CENTRAL
# ============================================================

self_protect() {
  if [ ! -f "$CENTRAL_META" ]; then
    log "ALERTA CRÍTICA: central.meta no existe."
    SELF_STATUS="no_meta"
    return
  fi

  if [ ! -f "$CENTRAL_BACKUP" ]; then
    log "ALERTA CRÍTICA: central.backup no existe."
    SELF_STATUS="no_backup"
    return
  fi

  CURRENT_HASH=$(sha256sum "$CENTRAL" | awk '{print $1}')
  EXPECTED_HASH=$(grep "^HASH=" "$CENTRAL_META" | cut -d'=' -f2)

  if [ "$CURRENT_HASH" != "$EXPECTED_HASH" ]; then
    log "ALERTA CRÍTICA: HASH NO coincide. Restaurando."
    cp "$CENTRAL_BACKUP" "$CENTRAL"
    chmod 700 "$CENTRAL"
    NEW_HASH=$(sha256sum "$CENTRAL" | awk '{print $1}')
    sed -i "s/^HASH=.*/HASH=$NEW_HASH/" "$CENTRAL_META"
    SELF_STATUS="restored"
  else
    SELF_STATUS="ok"
  fi
}

# ============================================================
# 1. PROTECCIÓN DE BÓVEDAS
# ============================================================

check_vault() {
  local file="$VAULT/github.env"

  if [ ! -f "$file" ]; then
    VAULT_STATUS="missing"
    VAULT_HASH=""
    VAULT_SIZE=0
    log "ALERTA: github.env NO existe."
    return
  fi

  perms=$(stat -c "%a" "$file")
  if [ "$perms" != "600" ]; then
    chmod 600 "$file"
    log "CORRECCIÓN: Permisos restaurados."
  fi

  VAULT_HASH=$(sha256sum "$file" | awk '{print $1}')
  VAULT_SIZE=$(stat -c "%s" "$file")
  VAULT_STATUS="ok"
}

# ============================================================
# 2. VERIFICACIÓN DE ESTRUCTURA
# ============================================================

check_structure() {
  REQUIRED=(
    "$BASE/00-GOBIERNO"
    "$BASE/00-GOBIERNO/VAULT"
    "$BASE/00-GOBIERNO/ESTADO"
    "$BASE/00-GOBIERNO/LOGS"
    "$BASE/00-GOBIERNO/META"
    "$BASE/02-SISTEMA"
    "$BASE/02-SISTEMA/BACKEND"
    "$BASE/02-SISTEMA/DERIVADOS"
    "$BASE/03-OPERACIONES"
  )

  STRUCTURE_STATUS="ok"

  for path in "${REQUIRED[@]}"; do
    if [ ! -d "$path" ]; then
      mkdir -p "$path"
      STRUCTURE_STATUS="corrected"
      log "CORRECCIÓN: Creada carpeta faltante: $path"
    fi
  done
}

# ============================================================
# 3. EJECUCIÓN DE DERIVADOS
# ============================================================

run_derivados() {
  DERIVADOS_STATUS="empty"

  for script in "$DERIVADOS"/*.sh; do
    [ -e "$script" ] || continue
    bash "$script"
    DERIVADOS_STATUS="ok"
  done
}

# ============================================================
# 4. GENERACIÓN DE ESTADO
# ============================================================

generate_state() {
  SELF_HASH=$(sha256sum "$CENTRAL" | awk '{print $1}')
  SELF_SIZE=$(stat -c "%s" "$CENTRAL")
  SELF_PERMS=$(stat -c "%a" "$CENTRAL")

  cat > "$STATEFILE" << EOF
{
  "timestamp": "$(timestamp)",
  "central": {
    "status": "$SELF_STATUS",
    "hash": "$SELF_HASH",
    "size": "$SELF_SIZE",
    "perms": "$SELF_PERMS"
  },
  "vault": {
    "status": "$VAULT_STATUS",
    "hash": "$VAULT_HASH",
    "size": "$VAULT_SIZE"
  },
  "structure": {
    "status": "$STRUCTURE_STATUS"
  },
  "derivados": {
    "status": "$DERIVADOS_STATUS"
  }
}
EOF

  log "Estado generado."
}

# ============================================================
# 5. EJECUCIÓN CENTRAL
# ============================================================

log "=== EJECUCIÓN IA‑SCRIPT CENTRAL ==="

self_protect
check_vault
check_structure
run_derivados
generate_state

log "=== FIN IA‑SCRIPT CENTRAL ==="

