# FASE 3 — FRONTEND SOBERANO DEL MONITOR-TERMUX V3
SODA-NEXUS — Documento Institucional  
Fecha: 2026-03-03  
Estado: APROBADO (Fase 3)

---

## 1. Propósito del Frontend

El frontend es la corteza visual del Monitor-Termux Soberano V3.  
Debe:

- Conectarse al backend local en `127.0.0.1:5051`.  
- Mostrar el estado del sistema (Dashboard / Latido Vital).  
- Permitir explorar carpetas de `~/soda/`.  
- Permitir ver contenido de archivos de texto.  
- Mostrar un timestamp de verdad (última respuesta real del backend).  
- Degradarse a modo “sin conexión” si el backend no responde.

---

## 2. Ubicación del Frontend

- Carpeta base de trabajo en Termux: `~/soda/docs/monitor/`  
- Más adelante, esta carpeta se integrará con el repositorio GitHub Pages (`/docs/`).

---

## 3. Componentes Mínimos Implementados en esta Fase

### 3.1. Dashboard (Latido Vital)

- Muestra:
  - Estado del backend (`online` / `offline`).  
  - Timestamp de última actualización.  

### 3.2. Explorador de Archivos (versión simple)

- Lista el contenido de una ruta relativa a `~/soda/`.  
- Permite navegar haciendo clic en carpetas.  
- Permite ver contenido de archivos de texto.

### 3.3. Modo Offline

- Si el backend no responde:
  - Se muestra estado `offline`.  
  - Se indica que se está sin conexión a Termux.  

---

## 4. Conexión con el Backend

El frontend se conecta a:

- `GET http://127.0.0.1:5051/estado`  
- `GET http://127.0.0.1:5051/carpetas?path=...`  
- `GET http://127.0.0.1:5051/archivo?path=...`

---

## 5. Estado de la Fase

FASE 3 — COMPLETADA (versión mínima funcional).  
Lista para ser extendida en fases posteriores (UI avanzada, Svelte, IA, logs en tiempo real).

