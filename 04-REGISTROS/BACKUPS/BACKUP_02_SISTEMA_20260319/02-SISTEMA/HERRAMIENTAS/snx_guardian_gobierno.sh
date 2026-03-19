#!/bin/bash
# [OBS 1.1] IA-SCRIPT DERIVADO: Guardián de 00-GOBIERNO.
# [OBS 1.2] Rol: verificar ESTADO, VAULT y HERRAMIENTAS de 00-GOBIERNO.
# [OBS 1.3] Alcance: solo lectura y reporte; no corrige nada.

GOB_ROOT="$HOME/soda/00-GOBIERNO"
ESTADO_DIR="$GOB_ROOT/ESTADO"
VAULT_DIR="$GOB_ROOT/VAULT"
HERR_DIR="$GOB_ROOT/HERRAMIENTAS"

ANOMALIES=0

echo "SNX-GUARDIAN-GOBIERNO v0.1 — Verificación de 00-GOBIERNO"
echo "Raíz de gobierno: $GOB_ROOT"
echo "----------------------------------------"

echo "Paso 1: Verificar ESTADO..."
if [ -d "$ESTADO_DIR" ]; then
  echo "[OK] Carpeta ESTADO presente."
  if [ -f "$ESTADO_DIR/snx_state.json" ]; then
    echo "[OK] Archivo de estado presente: snx_state.json"
  else
    echo "[ANOMALIA] Falta archivo de estado: snx_state.json en ESTADO/"
    ANOMALIES=$((ANOMALIES + 1))
  fi
else
  echo "[ANOMALIA] Falta carpeta ESTADO en 00-GOBIERNO."
  ANOMALIES=$((ANOMALIES + 1))
fi

echo "----------------------------------------"
echo "Paso 2: Verificar VAULT..."
if [ -d "$VAULT_DIR" ]; then
  echo "[OK] Carpeta VAULT presente."
  if [ -f "$VAULT_DIR/tunnel.env" ]; then
    echo "[OK] Archivo de bóveda presente: tunnel.env"
  else
    echo "[ANOMALIA] Falta archivo sensible mínimo: tunnel.env en VAULT/"
    ANOMALIES=$((ANOMALIES + 1))
  fi
else
  echo "[ANOMALIA] Falta carpeta VAULT en 00-GOBIERNO."
  ANOMALIES=$((ANOMALIES + 1))
fi

echo "----------------------------------------"
echo "Paso 3: Verificar HERRAMIENTAS..."
if [ -d "$HERR_DIR" ]; then
  echo "[OK] Carpeta HERRAMIENTAS presente."
  MISSING_TOOLS=0
  for tool in snx_fix_logs.sh snx_remove_legacy.sh snx_fix_final.sh; do
    if [ -f "$HERR_DIR/$tool" ]; then
      echo "[OK] Herramienta presente: $tool"
    else
      echo "[ANOMALIA] Falta herramienta esperada en HERRAMIENTAS/: $tool"
      MISSING_TOOLS=$((MISSING_TOOLS + 1))
    fi
  done
  ANOMALIES=$((ANOMALIES + MISSING_TOOLS))
else
  echo "[ANOMALIA] Falta carpeta HERRAMIENTAS en 00-GOBIERNO."
  ANOMALIES=$((ANOMALIES + 1))
fi

echo "----------------------------------------"
echo "Resumen de verificación de 00-GOBIERNO:"
echo "Anomalías detectadas: $ANOMALIES"

if [ "$ANOMALIES" -eq 0 ]; then
  echo "Estado: 00-GOBIERNO SOBERANO ESTABLE."
else
  echo "Estado: 00-GOBIERNO CON ANOMALIAS — revisar y corregir manualmente."
fi

# Pie Institucional:
# [PIE 1] SODA-NEXUS — IA-SCRIPT DERIVADO v0.1 (snx_guardian_gobierno.sh).
# [PIE 2] Rol: Guardián de la carpeta 00-GOBIERNO (ESTADO, VAULT, HERRAMIENTAS).
# [PIE 3] No modifica el sistema; solo observa y reporta.
# [PIE 4] Toda ampliación futura (más archivos, más bóvedas, más herramientas) debe extender este guardián.
