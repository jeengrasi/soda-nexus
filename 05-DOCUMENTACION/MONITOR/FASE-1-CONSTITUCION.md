# FASE 1 — CONSTITUCIÓN DEL MONITOR-TERMUX SOBERANO V3
SODA-NEXUS — Documento Institucional  
Fecha: 2026-03-03  
Estado: APROBADO (Fase 1)

---

## 1. Propósito del Monitor-Termux Soberano V3

El Monitor-Termux Soberano V3 es la interfaz visual oficial del Estado SODA‑NEXUS.  
Su función es extender Termux hacia una interfaz táctil, global, segura y auditable, sin reemplazarlo.

El monitor debe:

- Reflejar exactamente lo que ocurre en Termux.  
- Permitir operar el sistema desde una interfaz visual.  
- Mantener soberanía total (sin CDNs, sin dependencias externas).  
- Integrarse con IA Central para diagnóstico y contexto.  
- Garantizar antiamnesia mediante timestamp de verdad y estado cacheado.  
- Ser accesible globalmente desde GitHub Pages.

---

## 2. Principios Constitucionales del Monitor

### 2.1. Soberanía

- Sin dependencias externas (no CDNs, no trackers).  
- Todo el frontend vive en la carpeta `/docs/` del repositorio.  
- El backend vive en Termux y solo escucha en `127.0.0.1`.

### 2.2. Seguridad

- Whitelist estricta de rutas, limitadas a `~/soda/`.  
- Bloqueo absoluto de `00-GOBIERNO/VAULT`.  
- Sanitización de salida (ocultar secretos, hashes y rutas sensibles).  
- Autenticación híbrida (local sin token, remoto con HMAC).  
- Rate limiting en endpoints sensibles.

### 2.3. Auditoría

- Toda acción del monitor genera un registro en `05-LOGS/MONITOR/`.  
- Eventos críticos se registran inmediatamente.  
- Se mantienen hashes de integridad del frontend.  
- La documentación del monitor es versionada en Git.

### 2.4. Antiamnesia

- El monitor muestra un timestamp de verdad visible (último latido real de Termux).  
- Existe un modo offline con estado cacheado.  
- IA Central puede leer `state.json` y `decision_log.csv` para reconstruir contexto.

### 2.5. Fidelidad estructural

- El monitor refleja la estructura real de `~/soda/`.  
- Existen dos modos de navegación:  
  - Modo Estructura (por carpetas reales).  
  - Modo Ministerios (por función).

---

## 3. Arquitectura Oficial del Monitor V3

Capa Global (GitHub Pages):

- Ubicación: carpeta `/docs/` del repositorio `finanzas-brillantes`.  
- Contenido: HTML, CSS, JS, Svelte, assets y componentes.  
- Funciones clave:  
  - Renderizar la interfaz del monitor.  
  - Detectar si el backend local está disponible.  
  - Mostrar modo offline cuando Termux no responde.  
  - Mostrar el timestamp de verdad.

Capa Local (Termux):

- Backend implementado en Python (FastAPI) con soporte WebSocket.  
- Endpoints REST seguros para estado, archivos, procesos, logs, scripts y servicios.  
- Whitelist de scripts institucionales.  
- Validación de rutas para evitar acceso fuera de `~/soda/`.  
- Sanitización de salida para no exponer secretos.  
- Sistema de auditoría para registrar acciones del monitor.

Capa IA Central:

- Módulo de diagnóstico, resumen y análisis de logs.  
- Capacidad de generar recomendaciones y explicaciones del estado del sistema.  
- Exportación de un “context bundle” con estructura de carpetas, estado y eventos recientes.

---

## 4. Pestañas Oficiales del Monitor

### 4.1. Dashboard (Latido Vital)

- Estado del backend.  
- Semáforo de integridad del sistema.  
- Pulso del sistema (latido).  
- Alertas recientes.  
- Timestamp de verdad (última actualización real desde Termux).

### 4.2. Archivos (Miller Columns)

- Exploración completa de `~/soda/`.  
- Navegación jerárquica tipo columnas (Miller Columns).  
- Bloqueo visual de `00-GOBIERNO/VAULT`.  
- Posibilidad de ver archivos de texto permitidos.  
- Posibilidad de descargar archivos no sensibles.

### 4.3. Procesos

- Lista de procesos relevantes.  
- Estado de servicios institucionales (backend, túnel, daemons, etc.).  
- Posibilidad de reiniciar servicios autorizados.

### 4.4. Logs (Terminal Visual)

- Visor de logs en formato tipo terminal.  
- Streaming en tiempo real mediante WebSocket cuando Termux está online.  
- Filtros por gravedad (INFO, WARNING, ERROR, etc.).  
- Búsqueda dentro del log.  
- Descarga de logs permitidos.

### 4.5. Scripts

- Lista de scripts autorizados (whitelist).  
- Visualización del script antes de ejecutarlo.  
- Ejecución controlada de scripts institucionales.  
- Historial de ejecuciones con resultado y timestamp.

### 4.6. IA Central

- Diagnóstico del estado del sistema.  
- Resumen del estado actual a partir de `state.json` y logs.  
- Análisis de logs para detectar anomalías.  
- Sugerencias de acción para el Director.

### 4.7. Gobierno

- Acceso a documentos institucionales de `00-GOBIERNO/` (excepto VAULT).  
- Visualización del estado del sistema definido por gobierno.  
- Auditoría del propio monitor (verificación de integridad, cambios, versiones).

### 4.8. Operaciones

- Panel de trading y economía (03-OPERACIONES).  
- Estado de bots y motores económicos.  
- Métricas clave de rendimiento económico.

### 4.9. Comunicaciones

- Estado del bot de Telegram.  
- Estado de la WebApp.  
- Estado de túneles y canales de comunicación.

---

## 5. Endpoints Oficiales del Backend

Los siguientes endpoints forman parte de la interfaz oficial entre el monitor y Termux:

| Endpoint           | Método | Función                               |
|--------------------|--------|----------------------------------------|
| `/estado`          | GET    | Estado general del sistema             |
| `/carpetas`        | GET    | Lista de archivos y carpetas           |
| `/archivo`         | GET    | Lectura segura de archivos             |
| `/procesos`        | GET    | Lista de procesos                      |
| `/logs`            | GET    | Lectura de logs                        |
| `/ws/logs`         | WS     | Streaming de logs en tiempo real       |
| `/scripts`         | GET    | Lista de scripts autorizados           |
| `/scripts/ejecutar`| POST   | Ejecutar un script autorizado          |
| `/servicios`       | GET    | Estado de servicios institucionales    |
| `/ia`              | POST   | Análisis y diagnóstico vía IA Central  |

---

## 6. Seguridad Constitucional

- Rutas bloqueadas:  
  - `00-GOBIERNO/VAULT`  
  - Archivos con extensiones sensibles (`.env`, `.token`, `.shadow`, etc.).  

- Sanitización de salida:  
  - Ocultar secretos, hashes largos y rutas internas sensibles en cualquier salida mostrada en el monitor.  

- Whitelist de scripts:  
  - Archivo `allowed_scripts.json` define qué scripts pueden ejecutarse desde el monitor y dónde están ubicados.  

- Backend solo en `127.0.0.1`:  
  - El backend no expone puertos accesibles desde internet directamente.  

- Autenticación híbrida:  
  - Acceso local desde el propio dispositivo sin token.  
  - Acceso remoto (por túnel o red local) con token HMAC dinámico.

---

## 7. Auditoría Constitucional

- Cada acción relevante del monitor genera un evento en formato JSON.  
- Eventos críticos (ejecución de scripts, cambios de servicios, errores graves) se registran inmediatamente.  
- Los logs del monitor se almacenan en `05-LOGS/MONITOR/`.  
- Se mantienen hashes de integridad del frontend para detectar modificaciones no autorizadas.  
- La documentación del monitor se guarda en `06-DOCUMENTACION/MONITOR/` y se versiona con Git.

---

## 8. Estado de la Fase

FASE 1 — COMPLETADA  
Este documento constituye la Constitución del Monitor-Termux Soberano V3 y sirve como base obligatoria para las siguientes fases (backend, frontend, IA, auditoría, publicación y expansión).

