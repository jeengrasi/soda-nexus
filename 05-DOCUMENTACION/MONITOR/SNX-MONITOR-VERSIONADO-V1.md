# SODA-NEXUS — VERSIONADO DEL MONITOR SOBERANO
# Versión: V1
# Ubicación oficial: /soda/05-DOCUMENTACION/MONITOR/SNX-MONITOR-VERSIONADO-V1.md

## 1. Monitor oficial actual

- Versión: V4-OFICIAL
- Carpeta: /soda/06-MONITOR/V4-OFICIAL
- Backend asociado: snx_monitor_unificado_v2.py (puerto 5050)
- Descripción: Monitor Soberano unificado, conectado al backend y al Estado real.

## 2. Monitores en historial

- V1 → /soda/06-MONITOR/V1
- V2 → /soda/06-MONITOR/V2
- V3 → /soda/06-MONITOR/V3
- WEB/monitor (03-OPERACIONES) → Monitor histórico usado en 8080, preservado como referencia.

## 3. Backends del monitor

- OFICIAL: snx_monitor_unificado_v2.py → sirve V4-OFICIAL en 5050.
- HISTORIAL:
  - snx_monitor_unificado.py → versión previa con rutas duplicadas.
  - monitor_bridge_v1.py → bridge histórico.

## 4. Ley de preservación

- No borrar ninguna versión anterior del monitor.
- No sobrescribir archivos históricos.
- Toda nueva versión debe:
  - Crear nueva carpeta (V5-OFICIAL, V6-OFICIAL, etc.).
  - Actualizar MONITOR-REGISTRO.json.
  - Actualizar BACKEND-MONITOR-REGISTRO.json.
  - Registrar cambios en este documento.

# PIE DE PÁGINA INSTITUCIONAL — SODA-NEXUS
# 1. No modificar sin aprobación institucional.
# 2. No sobrescribir sin snapshot previo.
# 3. No inventar rutas ni estados.
# 4. Mantener coherencia con la estructura soberana.
# 5. Garantizar antiamnesia y auditabilidad total.
# 6. Ejecutar la mayoría de tareas en un solo chat.
