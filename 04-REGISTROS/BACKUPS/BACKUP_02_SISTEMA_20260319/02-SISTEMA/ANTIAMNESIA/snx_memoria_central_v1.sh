#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — MEMORIA CENTRAL V1
# Motor antiamnesia: resumen, chequeo de invariantes y paquete para IA.
# ============================================================================

set -e

SODA="$HOME/soda"
MEM_CANON="$SODA/01-MEMORIA/CANON"
MEM_ACTUAL="$SODA/01-MEMORIA/ACTUAL"

mkdir -p "$MEM_CANON" "$MEM_ACTUAL"

modo="$1"

detectar_ip() {
    # Intento best-effort, sin romper si falla
    if command -v ifconfig >/dev/null 2>&1; then
        ifconfig 2>/dev/null | awk '/wlan0/ {print $2}' | head -n1
    fi
}

modo_resumen() {
    local dest="$MEM_ACTUAL/SNX-RESUMEN-ACTUAL.md"
    local ip
    ip="$(detectar_ip || true)"

    {
        echo "# SNX — RESUMEN ACTUAL DEL SISTEMA"
        echo ""
        echo "## Fecha"
        date
        echo ""
        echo "## Raíz de SODA"
        echo '```'
        ls -1 "$SODA"
        echo '```'
        echo ""
        echo "## Monitor y backend"
        echo "- monitor_data.json: $SODA/06-MONITOR/V3/monitor_data.json"
        echo "- backend scripts:   $SODA/02-SCRIPTS/GLOBAL/"
        echo "- backend monitor:   $SODA/02-SISTEMA/BACKEND/MONITOR/"
        echo ""
        echo "## IP detectada (best-effort)"
        echo "${ip:-(no detectada)}"
        echo ""
        echo "## Scripts clave"
        echo '```'
        ls -1 "$SODA/02-SCRIPTS/GLOBAL" 2>/dev/null || echo "(sin listar)"
        echo '```'
        echo ""
        echo "## Fases registradas en raíz"
        echo '```'
        ls -1 "$SODA" | grep 'SNX-FASE' || echo "(sin fases en raíz)"
        echo '```'
        echo ""
        echo "## Nota para IA"
        echo "Este archivo existe para que el usuario lo copie y lo pegue en cualquier"
        echo "nueva sesión de IA, permitiendo rehidratar el contexto sin depender de"
        echo "memoria interna del modelo."
    } > "$dest"

    echo "[SNX] Resumen actualizado en: $dest"
}

modo_chequeo() {
    local errores=0

    check() {
        local desc="$1"
        local path="$2"
        if [ ! -e "$path" ]; then
            echo "[ERROR] Falta: $desc -> $path"
            errores=$((errores+1))
        fi
    }

    echo "[SNX] Chequeando invariantes básicas..."

    # Carpetas
    check "Carpeta 00-GOBIERNO" "$SODA/00-GOBIERNO"
    check "Carpeta 01-MEMORIA" "$SODA/01-MEMORIA"
    check "Carpeta 02-SCRIPTS" "$SODA/02-SCRIPTS"
    check "Carpeta 02-SISTEMA" "$SODA/02-SISTEMA"
    check "Carpeta 06-MONITOR" "$SODA/06-MONITOR"

    # Scripts clave
    check "Script central backend v3" "$SODA/02-SCRIPTS/GLOBAL/snx_central_backend_v3.sh"
    check "Backend monitor_soberano.py" "$SODA/02-SISTEMA/BACKEND/monitor_soberano.py"
    check "Lanzador backend monitor" "$SODA/02-SISTEMA/BACKEND/MONITOR/snx_monitor_backend_run.sh"

    # Archivos de estado
    check "monitor_data.json" "$SODA/06-MONITOR/V3/monitor_data.json"
    check "SNX-RESUMEN-ACTUAL.md" "$MEM_ACTUAL/SNX-RESUMEN-ACTUAL.md"

    if [ "$errores" -eq 0 ]; then
        echo "[SNX] ANTIAMNESIA OK — todas las invariantes básicas se cumplen."
        exit 0
    else
        echo "[SNX] ANTIAMNESIA ALERTA — se encontraron $errores problema(s)."
        exit 1
    fi
}

modo_paquete() {
    local dest="$MEM_ACTUAL/SNX-PAQUETE-IA-ACTUAL.md"
    local resumen="$MEM_ACTUAL/SNX-RESUMEN-ACTUAL.md"

    {
        echo "# SNX — PAQUETE DE CONTEXTO PARA IA"
        echo ""
        echo "## Guía mínima para IA"
        echo "- La memoria real del sistema está en Termux (~/soda), no en la IA."
        echo "- No inventes rutas ni estados: usa lo que ves aquí."
        echo "- No modifiques nada existente: solo propone archivos nuevos."
        echo "- Respeta la estructura, las fases y los scripts soberanos."
        echo ""
        echo "## Resumen actual del sistema"
        echo ""
        if [ -f "$resumen" ]; then
            cat "$resumen"
        else
            echo "(SNX-RESUMEN-ACTUAL.md no existe; ejecuta modo 'resumen' primero.)"
        fi
        echo ""
        echo "## Resultado del chequeo de invariantes"
        bash "$0" chequeo || true
    } > "$dest"

    echo "[SNX] Paquete IA generado en: $dest"
}

case "$modo" in
    resumen)  modo_resumen ;;
    chequeo)  modo_chequeo ;;
    paquete)  modo_paquete ;;
    *)
        echo "Uso: $0 {resumen|chequeo|paquete}"
        exit 1
        ;;
esac

# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL — SNX‑2026‑B
# • La memoria es Termux; la IA es desechable.
# • Este script es el motor antiamnesia del sistema.
# • Ninguna decisión debe tomarse sin consultar su salida.
# ============================================================================
