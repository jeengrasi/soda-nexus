#!/bin/bash
# [OBS 1.1] Shebang: define que este script se ejecuta con Bash en Termux.

# [OBS 1.2] Nombre: snx_guardian_central.sh — Versión 0.1 del IA-SCRIPT CENTRAL.
# [OBS 1.3] Propósito: verificar la estructura soberana de SODA-NEXUS y reportar anomalías básicas.
# [OBS 1.4] Alcance: solo lectura y reporte; no corrige, no borra, no mueve nada.
# [OBS 1.5] Estado: versión mínima funcional del Sistema Inmune Soberano.

SODA_ROOT="$HOME/soda"
# [OBS 2.1] SODA_ROOT: ruta raíz del sistema SODA-NEXUS dentro de Termux.

SOVEREIGN_FOLDERS=("00-GOBIERNO" "01-MEMORIA" "02-SISTEMA" "03-OPERACIONES" "04-REGISTROS" "05-DOCUMENTACION")
# [OBS 2.2] SOVEREIGN_FOLDERS: lista oficial de las seis carpetas soberanas permitidas por la ley.

ANOMALIES=0
# [OBS 2.3] ANOMALIES: contador de anomalías detectadas durante la verificación.

echo "SNX-GUARDIAN-CENTRAL v0.1 — Verificación de estructura soberana"
# [OBS 3.1] Mensaje inicial: indica inicio de la verificación.

echo "Raíz del sistema: $SODA_ROOT"
# [OBS 3.2] Muestra la ruta raíz que se está auditando.

echo "----------------------------------------"
# [OBS 3.3] Separador visual para claridad en la salida.

echo "Paso 1: Verificar que existan las seis carpetas soberanas..."
# [OBS 4.1] Anuncia el inicio de la verificación de existencia de carpetas soberanas.

for folder in "${SOVEREIGN_FOLDERS[@]}"; do
  # [OBS 4.2] Recorre cada carpeta soberana esperada.
  if [ -d "$SODA_ROOT/$folder" ]; then
    # [OBS 4.3] Si la carpeta existe, se informa como OK.
    echo "[OK] Carpeta soberana presente: $folder"
  else
    # [OBS 4.4] Si la carpeta no existe, se reporta como anomalía.
    echo "[ANOMALIA] Falta carpeta soberana: $folder"
    ANOMALIES=$((ANOMALIES + 1))
    # [OBS 4.5] Incrementa el contador de anomalías por cada carpeta faltante.
  fi
done

echo "----------------------------------------"
# [OBS 5.1] Separador visual entre pasos de verificación.

echo "Paso 2: Detectar carpetas no autorizadas en la raíz de SODA-NEXUS..."
# [OBS 5.2] Anuncia el inicio de la detección de carpetas no autorizadas.

if [ -d "$SODA_ROOT" ]; then
  # [OBS 5.3] Verifica que la raíz de SODA exista antes de inspeccionar su contenido.
  for item in "$SODA_ROOT"/*; do
    # [OBS 5.4] Recorre todos los elementos en la raíz de SODA.
    if [ -d "$item" ]; then
      # [OBS 5.5] Solo se consideran directorios para esta verificación.
      folder_name="$(basename "$item")"
      # [OBS 5.6] Obtiene el nombre de la carpeta sin la ruta completa.
      IS_SOVEREIGN="no"
      # [OBS 5.7] Bandera para determinar si la carpeta es soberana o no.
      for allowed in "${SOVEREIGN_FOLDERS[@]}"; do
        # [OBS 5.8] Recorre la lista de carpetas soberanas permitidas.
        if [ "$folder_name" = "$allowed" ]; then
          # [OBS 5.9] Si el nombre coincide con una carpeta soberana, se marca como permitida.
          IS_SOVEREIGN="yes"
          break
          # [OBS 5.10] Sale del bucle interno al encontrar coincidencia.
        fi
      done
      if [ "$IS_SOVEREIGN" = "no" ]; then
        # [OBS 5.11] Si la carpeta no es soberana, se reporta como no autorizada.
        echo "[ANOMALIA] Carpeta no autorizada detectada en raíz: $folder_name"
        ANOMALIES=$((ANOMALIES + 1))
        # [OBS 5.12] Incrementa el contador de anomalías por cada carpeta no autorizada.
      else
        # [OBS 5.13] Si la carpeta es soberana, se puede opcionalmente informar como validada.
        echo "[OK] Carpeta soberana validada en raíz: $folder_name"
      fi
    fi
  done
else
  # [OBS 5.14] Si la raíz de SODA no existe, se reporta como anomalía crítica.
  echo "[ANOMALIA] La ruta raíz de SODA-NEXUS no existe: $SODA_ROOT"
  ANOMALIES=$((ANOMALIES + 1))
fi

echo "----------------------------------------"
# [OBS 6.1] Separador visual antes del resumen final.

echo "Resumen de verificación del IA-SCRIPT CENTRAL v0.1:"
# [OBS 6.2] Encabezado del resumen de resultados.

echo "Anomalías detectadas: $ANOMALIES"
# [OBS 6.3] Muestra el número total de anomalías encontradas.

if [ "$ANOMALIES" -eq 0 ]; then
  # [OBS 6.4] Si no hay anomalías, se declara la estructura como estable.
  echo "Estado: ESTRUCTURA SOBERANA ESTABLE (sin anomalías detectadas)."
else
  # [OBS 6.5] Si hay anomalías, se indica que se requiere revisión manual.
  echo "Estado: ESTRUCTURA CON ANOMALIAS — revisar salidas anteriores y corregir manualmente."
fi

# [OBS 7.1] Fin de la ejecución del script v0.1; no se realizan acciones de corrección.
# [OBS 7.2] Este script puede ser llamado manualmente o desde un futuro daemon.

exit 0
# [OBS 7.3] Finaliza el script con código de salida 0, indicando que la ejecución técnica fue correcta.

# Pie Institucional:
# [PIE 1] SODA-NEXUS — IA-SCRIPT CENTRAL v0.1 (snx_guardian_central.sh).
# [PIE 2] Rol: Versión mínima del Sistema Inmune Soberano para verificación de estructura.
# [PIE 3] Este script no modifica el sistema; solo observa y reporta.
# [PIE 4] Toda ampliación futura (snapshots, hashes, alertas, agentes derivados) debe respetar esta base.
# [PIE 5] Emitido bajo la dirección del Estado Soberano SODA-NEXUS y el Director Soberano Jeisson.
