# FASE 2 — BACKEND SOBERANO DEL MONITOR-TERMUX V3
SODA-NEXUS — Documento Institucional  
Fecha: 2026-03-03  
Estado: APROBADO (Fase 2)

---

## 1. Propósito del Backend Soberano

El backend es la capa local que permite que el monitor global (GitHub Pages) lea el estado real de Termux.  
Debe ser:

- Seguro  
- Local  
- Ligero  
- Auditable  
- Soberano  
- Compatible con IA Central  
- Sin exponer secretos  
- Sin abrir puertos públicos  

---

## 2. Estructura Oficial del Backend

Ubicación:

- Carpeta base: `~/soda/02-SISTEMA/BACKEND/MONITOR/`
- Archivos principales:
  - `snx_monitor_backend.py`
  - `allowed_scripts.json`
  - `audit_logger.py`
  - `path_security.py`

---

## 3. Endpoints Oficiales Implementados

- `/estado` — Estado general del sistema  
- `/carpetas` — Lista de archivos y carpetas  
- `/archivo` — Lectura segura de archivos  
- `/procesos` — Lista de procesos  
- `/logs` — Lectura de logs  
- `/ws/logs` — Streaming de logs  
- `/scripts` — Lista de scripts autorizados  
- `/scripts/ejecutar` — Ejecutar script autorizado  
- `/servicios` — Estado de servicios  
- `/ia` — Análisis IA (placeholder)

---

## 4. Seguridad Implementada

- Validación de rutas con `realpath`  
- Bloqueo de VAULT y archivos sensibles  
- Sanitización de salida  
- Whitelist de scripts  
- Backend solo en `127.0.0.1`  
- Auditoría de acciones  

---

## 5. Código del Backend (FastAPI)

El siguiente archivo implementa el backend completo:

Archivo: `snx_monitor_backend.py`

(El código se incluye fuera del Markdown para no romper formato.)

---

## 6. Estado de la Fase

FASE 2 — COMPLETADA  
Backend listo para pruebas y conexión con el frontend en Fase 3.

