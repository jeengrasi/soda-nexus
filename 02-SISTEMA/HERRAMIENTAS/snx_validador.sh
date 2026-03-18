#!/usr/bin/env bash
# OBS: Shebang: ejecuta este script con bash en Termux.

# OBS: Verifica que se haya pasado un archivo como argumento.
if [ $# -lt 1 ]; then
  echo "[SNX-VALIDADOR] ERROR: Debes indicar el script a validar."  # OBS: Mensaje si falta argumento.
  echo "Uso: snx_validador.sh ruta/al/script.sh"                    # OBS: Ejemplo de uso.
  exit 1                                                           # OBS: Salir con error.
fi

TARGET="$1"                                                        # OBS: Script objetivo a validar.
BASENAME="$(basename "$TARGET")"                                   # OBS: Nombre corto del script.

# OBS: Verifica que el archivo exista.
if [ ! -f "$TARGET" ]; then
  echo "[SNX-VALIDADOR] ERROR: El archivo '$TARGET' no existe."    # OBS: Mensaje si no existe.
  exit 1                                                           # OBS: Salir con error.
fi

# OBS: Inicializa banderas de validación.
HAS_HEADER=0                                                       # OBS: Indica si tiene encabezado institucional.
HAS_FOOTER=0                                                       # OBS: Indica si tiene pie de página institucional.
MISSING_OBS=0                                                      # OBS: Indica si faltan observaciones en líneas.
FORBIDDEN_CMD=0                                                    # OBS: Indica si hay comandos prohibidos.
FORBIDDEN_PATH=0                                                   # OBS: Indica si hay rutas prohibidas.

# OBS: Patrones institucionales.
HEADER_PATTERN="SNX —"                                             # OBS: Texto que identifica encabezado SNX.
FOOTER_PATTERN="SNX — PIE DE PÁGINA INSTITUCIONAL"                 # OBS: Texto que identifica pie de página SNX.
OBS_PATTERN="# OBS:"                                               # OBS: Texto que identifica observaciones por línea.

# OBS: Comandos prohibidos sin supervisión.
FORBIDDEN_CMDS=("rm " "rm-" "rm\t" "mkdir " "mkfs" "dd " "chmod 777" "chown " "cat >" "truncate " "mv /" "rm -rf")  # OBS: Lista de comandos peligrosos.

# OBS: Rutas prohibidas o sospechosas.
FORBIDDEN_PATHS=("02-SCRIPTS" "LEGACY" "/tmp/" "../" "/data/data/com.termux/files/home/soda/tmp")  # OBS: Rutas que no deben usarse.

LINE_NUM=0                                                         # OBS: Contador de líneas.

# OBS: Recorre el archivo línea por línea para validar.
while IFS= read -r LINE; do
  LINE_NUM=$((LINE_NUM + 1))                                       # OBS: Incrementa número de línea.

  # OBS: Detecta encabezado institucional.
  if echo "$LINE" | grep -q "$HEADER_PATTERN"; then
    HAS_HEADER=1                                                   # OBS: Marca que el encabezado existe.
  fi

  # OBS: Detecta pie de página institucional.
  if echo "$LINE" | grep -q "$FOOTER_PATTERN"; then
    HAS_FOOTER=1                                                   # OBS: Marca que el pie de página existe.
  fi

  # OBS: Omite líneas vacías.
  if [ -z "$LINE" ]; then
    continue                                                       # OBS: Saltar líneas vacías.
  fi

  # OBS: Omite líneas que son solo comentarios.
  if echo "$LINE" | grep -qE '^[[:space:]]*#'; then
    continue                                                       # OBS: Saltar comentarios puros.
  fi

  # OBS: Verifica que la línea tenga observaciones [OBS].
  if ! echo "$LINE" | grep -q "$OBS_PATTERN"; then
    echo "[SNX-VALIDADOR] FALTA OBS en $BASENAME:$LINE_NUM -> $LINE"  # OBS: Reporta línea sin observación.
    MISSING_OBS=1                                                  # OBS: Marca que faltan observaciones.
  fi

  # OBS: Busca comandos prohibidos en la línea.
  for CMD in "${FORBIDDEN_CMDS[@]}"; do
    if echo "$LINE" | grep -q "$CMD"; then
      echo "[SNX-VALIDADOR] COMANDO PROHIBIDO en $BASENAME:$LINE_NUM -> $LINE"  # OBS: Reporta comando peligroso.
      FORBIDDEN_CMD=1                                              # OBS: Marca presencia de comando prohibido.
    fi
  done

  # OBS: Busca rutas prohibidas en la línea.
  for PTH in "${FORBIDDEN_PATHS[@]}"; do
    if echo "$LINE" | grep -q "$PTH"; then
      echo "[SNX-VALIDADOR] RUTA PROHIBIDA en $BASENAME:$LINE_NUM -> $LINE"  # OBS: Reporta ruta peligrosa.
      FORBIDDEN_PATH=1                                             # OBS: Marca presencia de ruta prohibida.
    fi
  done

done < "$TARGET"

# OBS: Verifica encabezado institucional.
if [ $HAS_HEADER -eq 0 ]; then
  echo "[SNX-VALIDADOR] ERROR: El script '$BASENAME' NO tiene encabezado institucional SNX."  # OBS: Mensaje si falta encabezado.
fi

# OBS: Verifica pie de página institucional.
if [ $HAS_FOOTER -eq 0 ]; then
  echo "[SNX-VALIDADOR] ERROR: El script '$BASENAME' NO tiene pie de página institucional SNX."  # OBS: Mensaje si falta pie de página.
fi

# OBS: Si falta encabezado, pie de página, observaciones o hay comandos/rutas prohibidas, se bloquea ejecución.
if [ $HAS_HEADER -eq 0 ] || [ $HAS_FOOTER -eq 0 ] || [ $MISSING_OBS -ne 0 ] || [ $FORBIDDEN_CMD -ne 0 ] || [ $FORBIDDEN_PATH -ne 0 ]; then
  echo "[SNX-VALIDADOR] EJECUCIÓN BLOQUEADA para '$BASENAME'."     # OBS: Bloquea ejecución por incumplimiento.
  exit 1                                                           # OBS: Salir con error institucional.
fi

# OBS: Si todo está correcto, se permite la ejecución del script objetivo.
echo "[SNX-VALIDADOR] VALIDACIÓN COMPLETA. Ejecutando '$BASENAME'..."  # OBS: Mensaje de éxito.
bash "$TARGET"                                                     # OBS: Ejecuta el script validado.

# --------------------------------------------------------------
# SNX — PIE DE PÁGINA INSTITUCIONAL (VERSIÓN OFICIAL 2026)
# Este script pertenece al sistema soberano SODA‑NEXUS.
#
# ESTRUCTURA SOBERANA:
# 00-GOBIERNO, 01-MEMORIA, 02-SISTEMA,
# 03-OPERACIONES, 04-REGISTROS, 05-DOCUMENTACION, 99-TMP.
#
# REGLAS INSTITUCIONALES:
# 1. Antes de modificar, SIEMPRE inspeccionar el filesystem real.
# 2. No crear carpetas nuevas sin aprobación institucional.
# 3. No eliminar archivos sin clasificación previa.
# 4. No sobrescribir scripts sin diagnóstico y evidencia.
# 5. Todas las tareas deben ejecutarse en el MISMO chat para evitar amnesia.
# 6. Cada línea del script debe incluir observaciones [OBS].
# 7. Todo script debe ser auditable, reversible y sin efectos colaterales.
# 8. VAULT, ESTADO y REGISTROS son carpetas CRÍTICAS.
# 9. Ningún script debe depender de servicios externos sin aprobación.
# 10. Todo cambio debe registrarse en snx_state.json (cuando exista IA‑SCRIPT CENTRAL).
#
# REGLAS DE AUDITORÍA:
# - Detectar carpetas fantasma (referenciadas pero inexistentes).
# - Detectar carpetas sospechosas (fuera de la estructura soberana).
# - Detectar carpetas vacías inesperadas.
# - Detectar rutas rotas o scripts heredados.
# - Reportar anomalías antes de actuar.
#
# REGLAS DE DOCUMENTACIÓN:
# - Cada script debe incluir encabezado, observaciones y pie de página.
# - Cada línea debe explicar su propósito con [OBS].
# - Ningún script debe contener lógica oculta o ambigua.
# --------------------------------------------------------------
