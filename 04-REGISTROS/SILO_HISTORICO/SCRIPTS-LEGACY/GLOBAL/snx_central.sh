#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# IA-SCRIPT CENTRAL — SODA-NEXUS
# Autoridad soberana, notarial, auditora y antiamnesia del sistema.
# Ninguna acción se ejecuta sin aprobación explícita del Director.
# ============================================================================

SODA="$HOME/soda"
REGISTROS="$SODA/05-REGISTROS/GUARDIAN/SESIONES"
ALERTAS="$SODA/05-REGISTROS/GUARDIAN/ALERTAS"
MONITOR_DATA="$SODA/06-MONITOR/V3/monitor_data.json"
BACKEND="$SODA/02-SISTEMA/BACKEND"

mkdir -p "$REGISTROS" "$ALERTAS"

timestamp() { date +"%Y-%m-%d %H:%M:%S"; }

registrar() {
    local mensaje="$1"
    local archivo="$REGISTROS/snx_sesion_$(date +"%Y%m%d_%H%M%S").log"
    echo "[$(timestamp)] $mensaje" >> "$archivo"
}

alerta() {
    local mensaje="$1"
    local archivo="$ALERTAS/alerta_$(date +"%Y%m%d_%H%M%S").log"
    echo "[$(timestamp)] ALERTA: $mensaje" >> "$archivo"
}

confirmar() {
    echo ""
    echo "⚠️  ADVERTENCIA INSTITUCIONAL"
    echo "$1"
    echo ""
    read -p "¿Desea continuar? (ESCRIBA: SI) → " resp
    if [ "$resp" != "SI" ]; then
        echo "❌ Operación cancelada por el Director."
        registrar "Operación cancelada: $1"
        exit 1
    fi
}

menu() {
    clear
    echo "=============================================================="
    echo " IA-SCRIPT CENTRAL — SODA-NEXUS"
    echo " Autoridad soberana, notarial, auditora y antiamnesia"
    echo "=============================================================="
    echo ""
    echo "1) Generar monitor_data.json"
    echo "2) Lanzar servidor del Monitor"
    echo "3) Ejecutar Guardian"
    echo "4) Ver estado del sistema"
    echo "5) Salir"
    echo ""
    read -p "Seleccione una opción: " op

    case $op in
        1)
            confirmar "Se generará monitor_data.json. No se modificará el sistema."
            registrar "Generando monitor_data.json"
            python3 "$BACKEND/monitor_soberano.py" > "$MONITOR_DATA"
            echo "✔ monitor_data.json generado."
            registrar "monitor_data.json generado correctamente"
            ;;
        2)
            confirmar "Se lanzará un servidor HTTP local para visualizar el Monitor."
            registrar "Lanzando servidor del Monitor"
            cd "$SODA/06-MONITOR/V3"
            python3 -m http.server 8080
            ;;
        3)
            confirmar "Se ejecutará el Guardian Soberano."
            registrar "Ejecutando Guardian"
            bash "$SODA/02-SISTEMA/GUARDIAN/snx_guardian.sh"
            ;;
        4)
            echo ""
            echo "📌 Estado actual del sistema:"
            echo ""
            ls -1 "$SODA"
            registrar "Consultado estado del sistema"
            ;;
        5)
            registrar "Salida del IA-SCRIPT CENTRAL"
            exit 0
            ;;
        *)
            echo "Opción inválida."
            ;;
    esac

    read -p "Presione ENTER para continuar..."
    menu
}

menu

# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL
# Este script es la autoridad soberana del sistema.
# Ninguna acción se ejecuta sin aprobación explícita del Director.
# Toda operación queda registrada y notariada.
# ============================================================================
