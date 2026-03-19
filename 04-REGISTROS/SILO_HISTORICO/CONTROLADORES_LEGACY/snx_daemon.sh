#!/usr/bin/env bash
# SNX — DAEMON INSTITUCIONAL 2026  # OBS: Encabezado institucional del daemon.

BACKEND_SCRIPT="/data/data/com.termux/files/home/soda/02-SISTEMA/BACKEND/snx_monitor_backend.py"  # OBS: Ruta backend.
PYTHON_BIN="python"                                         # OBS: Comando Python.
SLEEP_SECONDS=10                                            # OBS: Intervalo entre chequeos.

check_backend() {                                           # OBS: Verifica si backend está corriendo.
  pgrep -f "snx_monitor_backend.py" > /dev/null 2>&1        # OBS: Busca proceso por nombre.
}

start_backend() {                                           # OBS: Inicia backend si no está corriendo.
  echo "[SNX-DAEMON] Iniciando backend..."                  # OBS: Mensaje de inicio.
  nohup "$PYTHON_BIN" "$BACKEND_SCRIPT" >/dev/null 2>&1 &   # OBS: Ejecuta backend en segundo plano.
}

loop() {                                                    # OBS: Bucle principal del daemon.
  while true; do                                            # OBS: Loop infinito controlado.
    if ! check_backend; then                                # OBS: Si backend no está activo.
      echo "[SNX-DAEMON] Backend caído, reiniciando..."     # OBS: Mensaje de alerta.
      start_backend                                         # OBS: Llama a función de inicio.
    fi
    sleep "$SLEEP_SECONDS"                                  # OBS: Espera antes del siguiente chequeo.
  done
}

loop                                                        # OBS: Ejecuta bucle principal.

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
