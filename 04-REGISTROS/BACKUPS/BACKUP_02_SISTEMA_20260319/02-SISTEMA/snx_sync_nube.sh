#!/data/data/com.termux/files/usr/bin/bash
# SNX — SINCRONIZADOR NUBE V1
cd ~/soda
git add .
git commit -m "SNX: Sincronización Automática - $(date)"
git push origin master --force
# OBS: Uso force porque el repositorio en la nube debe obedecer a Termux.
