#!/data/data/com.termux/files/usr/bin/bash

BASE="$HOME/soda"

echo "=== SANEAMIENTO TOTAL SODA-NEXUS ==="

# Crear las 6 carpetas finales si no existen
mkdir -p $BASE/00-GOBIERNO
mkdir -p $BASE/01-MEMORIA
mkdir -p $BASE/02-SISTEMA
mkdir -p $BASE/03-OPERACIONES
mkdir -p $BASE/04-REGISTROS
mkdir -p $BASE/05-DOCUMENTACION

echo "[1/6] Moviendo contenido a 00-GOBIERNO/"
mv -f $BASE/00-VAULT/* $BASE/00-GOBIERNO/ 2>/dev/null
mv -f $BASE/VAULT/* $BASE/00-GOBIERNO/ 2>/dev/null
mv -f $BASE/STATE/* $BASE/00-GOBIERNO/ 2>/dev/null
mv -f $BASE/KEYS $BASE/00-GOBIERNO/ 2>/dev/null
mv -f $BASE/ESTADO $BASE/00-GOBIERNO/ 2>/dev/null

echo "[2/6] Moviendo contenido a 01-MEMORIA/"
mv -f $BASE/01-ARCHIVO-HISTORICO/* $BASE/01-MEMORIA/ 2>/dev/null
mv -f $BASE/01-MINISTERIOS/* $BASE/01-MEMORIA/ 2>/dev/null
mv -f $BASE/DECISIONES $BASE/01-MEMORIA/ 2>/dev/null
mv -f $BASE/EVENTOS $BASE/01-MEMORIA/ 2>/dev/null
mv -f $BASE/LECCIONES $BASE/01-MEMORIA/ 2>/dev/null
mv -f $BASE/REFERENCIAS $BASE/01-MEMORIA/ 2>/dev/null
mv -f $BASE/SNAPSHOTS $BASE/01-MEMORIA/ 2>/dev/null

echo "[3/6] Moviendo contenido a 02-SISTEMA/"
mv -f $BASE/02-SCRIPTS/* $BASE/02-SISTEMA/ 2>/dev/null
mv -f $BASE/API/* $BASE/02-SISTEMA/ 2>/dev/null
mv -f $BASE/CORE/* $BASE/02-SISTEMA/ 2>/dev/null
mv -f $BASE/DAEMON/* $BASE/02-SISTEMA/ 2>/dev/null
mv -f $BASE/MODULES/* $BASE/02-SISTEMA/ 2>/dev/null
mv -f $BASE/ENGINE/* $BASE/02-SISTEMA/ 2>/dev/null
mv -f $BASE/IMMUNITY/* $BASE/02-SISTEMA/ 2>/dev/null
mv -f $BASE/MIM/* $BASE/02-SISTEMA/ 2>/dev/null
mv -f $BASE/TUNNEL/* $BASE/02-SISTEMA/ 2>/dev/null

echo "[4/6] Moviendo contenido a 03-OPERACIONES/"
mv -f $BASE/ECONOMY/* $BASE/03-OPERACIONES/ 2>/dev/null
mv -f $BASE/BRIDGES/* $BASE/03-OPERACIONES/ 2>/dev/null
mv -f $BASE/CLI/* $BASE/03-OPERACIONES/ 2>/dev/null
mv -f $BASE/TELEGRAM/* $BASE/03-OPERACIONES/ 2>/dev/null
mv -f $BASE/WEBAPP/* $BASE/03-OPERACIONES/ 2>/dev/null

echo "[5/6] Moviendo contenido a 04-REGISTROS/"
mv -f $BASE/05-LOGS/* $BASE/04-REGISTROS/ 2>/dev/null
mv -f $BASE/05-REGISTROS/* $BASE/04-REGISTROS/ 2>/dev/null
mv -f $BASE/LOGS/* $BASE/04-REGISTROS/ 2>/dev/null
mv -f $BASE/INCIDENTS/* $BASE/04-REGISTROS/ 2>/dev/null
mv -f $BASE/SYSTEM/* $BASE/04-REGISTROS/ 2>/dev/null
mv -f $BASE/TUNNEL/* $BASE/04-REGISTROS/ 2>/dev/null
mv -f $BASE/OANDA/* $BASE/04-REGISTROS/ 2>/dev/null
mv -f $BASE/WEBAPP/logs/* $BASE/04-REGISTROS/ 2>/dev/null

echo "[6/6] Moviendo contenido a 05-DOCUMENTACION/"
mv -f $BASE/06-DOCUMENTACION/* $BASE/05-DOCUMENTACION/ 2>/dev/null
mv -f $BASE/00-DOCS/* $BASE/05-DOCUMENTACION/ 2>/dev/null
mv -f $BASE/ARCHIVO/* $BASE/05-DOCUMENTACION/ 2>/dev/null
mv -f $BASE/MANUALES/* $BASE/05-DOCUMENTACION/ 2>/dev/null
mv -f $BASE/ARQUITECTURA/* $BASE/05-DOCUMENTACION/ 2>/dev/null
mv -f $BASE/REPORTES/* $BASE/05-DOCUMENTACION/ 2>/dev/null
mv -f $BASE/EXPORTS/* $BASE/05-DOCUMENTACION/ 2>/dev/null

echo "Eliminando carpetas vacías..."
find $BASE -type d -empty -delete

echo "=== SANEAMIENTO COMPLETO ==="
