#!/bin/bash

BASE="$HOME/soda"
VAULT="$BASE/00-GOBIERNO/VAULT"
ESTADO="$BASE/00-GOBIERNO/ESTADO"
LOGS="$BASE/00-GOBIERNO/LOGS"

LOGFILE="$LOGS/push_state.log"
STATEFILE="$ESTADO/snx_state.json"
TMP_REPO="$BASE/99-TMP/push_repo"

timestamp() { date +"%Y-%m-%d %H:%M:%S"; }

log() {
  echo "$(timestamp) — $1" >> "$LOGFILE"
}

if [ ! -f "$VAULT/github.env" ]; then
  log "ERROR: github.env no existe."
  exit 1
fi

. "$VAULT/github.env"

if [ -z "$GITHUB_USER" ] || [ -z "$GITHUB_REPO" ] || [ -z "$GITHUB_TOKEN" ]; then
  log "ERROR: Variables GITHUB_* incompletas."
  exit 1
fi

if [ ! -f "$STATEFILE" ]; then
  log "ERROR: snx_state.json no existe."
  exit 1
fi

mkdir -p "$BASE/99-TMP"
rm -rf "$TMP_REPO"

log "Clonando repositorio $GITHUB_USER/$GITHUB_REPO..."
git clone "https://github.com/$GITHUB_USER/$GITHUB_REPO.git" "$TMP_REPO" >> "$LOGFILE" 2>&1 || {
  log "ERROR: fallo al clonar repositorio."
  exit 1
}

cd "$TMP_REPO" || exit 1

cp "$STATEFILE" ./state.json

git add state.json >> "$LOGFILE" 2>&1
git commit -m "update state" >> "$LOGFILE" 2>&1 || log "INFO: nada que commitear."

log "Haciendo push..."
git push "https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/$GITHUB_REPO.git" >> "$LOGFILE" 2>&1 || {
  log "ERROR: fallo al hacer push."
  cd "$BASE"
  rm -rf "$TMP_REPO"
  exit 1
}

cd "$BASE"
rm -rf "$TMP_REPO"

log "Estado subido correctamente."
