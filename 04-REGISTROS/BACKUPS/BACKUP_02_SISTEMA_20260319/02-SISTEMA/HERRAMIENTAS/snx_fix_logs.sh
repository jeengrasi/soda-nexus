#!/data/data/com.termux/files/usr/bin/bash

BASE="$HOME/soda"

echo "Moviendo logs.txt a 04-REGISTROS..."
mv -f $BASE/00-GOBIERNO/logs.txt $BASE/04-REGISTROS/ 2>/dev/null

echo "Corrección completada."
