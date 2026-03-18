#!/data/data/com.termux/files/usr/bin/bash
# ============================================================================
# SNX — NEUTRALIZACIÓN DEL BACKEND LEGACY
# Este script desactiva el servicio runit "snx_backend_monitor" sin eliminarlo.
# ============================================================================
# OBS: Este servicio ejecuta el backend antiguo snx_backend_monitor.py.
# OBS: Interfiere con el backend moderno ubicado en BACKEND/MONITOR.
# OBS: Debe ser neutralizado para evitar conflictos de puertos y procesos.

SERVICE_DIR="$PREFIX/var/service/snx_backend_monitor"

echo "[SNX] Neutralizando servicio legacy: snx_backend_monitor"

# 1. Apagar el servicio si está activo
# OBS: 'sv down' detiene el servicio sin eliminarlo.
sv down snx_backend_monitor 2>/dev/null || true

# 2. Crear archivo 'down' para evitar que runit lo levante
# OBS: Este archivo indica a runit que el servicio debe permanecer apagado.
touch "$SERVICE_DIR/down"

# 3. Reemplazar el script run con un stub vacío
# OBS: Esto evita que el backend legacy se ejecute accidentalmente.
cat > "$SERVICE_DIR/run" << 'EOF2'
#!/data/data/com.termux/files/usr/bin/bash
# Servicio legacy neutralizado por SODA‑NEXUS.
# No ejecutar. No modificar.
exit 0
EOF2

chmod +x "$SERVICE_DIR/run"

echo "[SNX] Servicio legacy neutralizado correctamente."
echo "[SNX] El backend moderno es ahora el único backend activo."

# ============================================================================
# SNX — PIE DE PÁGINA INSTITUCIONAL
# Este script pertenece a la FASE 2 — Estabilización del Backend.
# No elimina archivos legacy; solo los neutraliza.
# Prohibido modificar sin fase aprobada.
# Antes de cualquier cambio, SIEMPRE inspeccionar el filesystem real.
# ============================================================================
