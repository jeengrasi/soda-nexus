#!/data/data/com.termux/files/usr/bin/bash

BASE="$HOME/soda"

echo "=== CORRECCIÓN FINAL SODA-NEXUS ==="

# Asegurar las 6 carpetas soberanas
mkdir -p $BASE/00-GOBIERNO
mkdir -p $BASE/01-MEMORIA
mkdir -p $BASE/02-SISTEMA
mkdir -p $BASE/03-OPERACIONES
mkdir -p $BASE/04-REGISTROS
mkdir -p $BASE/05-DOCUMENTACION

echo "[1/8] Moviendo 03-CONFIG → 02-SISTEMA/TUNNEL"
mkdir -p $BASE/02-SISTEMA/TUNNEL
mv -f $BASE/03-CONFIG/tunnel/* $BASE/02-SISTEMA/TUNNEL/ 2>/dev/null
rm -rf $BASE/03-CONFIG

echo "[2/8] Moviendo 04-COMUNICACIONES → 03-OPERACIONES"
mv -f $BASE/04-COMUNICACIONES/* $BASE/03-OPERACIONES/ 2>/dev/null
rm -rf $BASE/04-COMUNICACIONES

echo "[3/8] Moviendo backups → 01-MEMORIA"
mkdir -p $BASE/01-MEMORIA/BACKUPS
mv -f $BASE/backups/* $BASE/01-MEMORIA/BACKUPS/ 2>/dev/null
rm -rf $BASE/backups

echo "[4/8] Moviendo scripts sueltos → 02-SISTEMA/GLOBAL"
mkdir -p $BASE/02-SISTEMA/GLOBAL
mv -f $BASE/snx_*.sh $BASE/02-SISTEMA/GLOBAL/ 2>/dev/null

echo "[5/8] Moviendo documentación suelta → 05-DOCUMENTACION"
mv -f $BASE/TODO_EL_SISTEMA.txt $BASE/05-DOCUMENTACION/ 2>/dev/null
mv -f $BASE/TODO_SPLIT $BASE/05-DOCUMENTACION/ 2>/dev/null

echo "[6/8] Limpiando 01-MEMORIA/02-SCRIPTS (symlinks recursivos)"
rm -f $BASE/01-MEMORIA/02-SCRIPTS/AUDIT/AUDIT 2>/dev/null
rm -f $BASE/01-MEMORIA/02-SCRIPTS/ENGINE/ENGINE 2>/dev/null
rm -f $BASE/01-MEMORIA/02-SCRIPTS/GLOBAL/GLOBAL 2>/dev/null
rm -f $BASE/01-MEMORIA/02-SCRIPTS/MODULES/ECONOMY/ECONOMY 2>/dev/null

echo "[7/8] Moviendo 01-MEMORIA/02-SCRIPTS → 02-SISTEMA/HISTORICO"
mkdir -p $BASE/02-SISTEMA/HISTORICO
mv -f $BASE/01-MEMORIA/02-SCRIPTS/* $BASE/02-SISTEMA/HISTORICO/ 2>/dev/null
rm -rf $BASE/01-MEMORIA/02-SCRIPTS

echo "[8/8] Eliminando carpetas vacías"
find $BASE -type d -empty -delete

echo "=== CORRECCIÓN COMPLETA ==="
