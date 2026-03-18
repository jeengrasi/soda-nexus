# CONTEXTO GENERAL — MONITOR-TERMUX SOBERANO V3  
SODA‑NEXUS — Documento Institucional  
Fecha: 2026‑03‑04  
Estado: ACTIVO

---

## 1. Fin supremo del proyecto SODA‑NEXUS

SODA‑NEXUS es una **institución digital soberana**, diseñada para garantizar que Jeisson:

- tenga **control total** sobre su infraestructura, datos, procesos y memoria;  
- elimine para siempre la **amnesia institucional**, el desorden y la pérdida de contexto;  
- convierta cada acción en un **activo documentado, auditable y reutilizable**;  
- opere con **seguridad, trazabilidad y resiliencia** sin depender de terceros;  
- y logre su objetivo central:  
  **la libertad financiera mediante automatización soberana, trading, monitoreo y control total del sistema.**

SODA‑NEXUS no es un proyecto técnico:  
es un **Estado digital**, con leyes, ministerios, fases, memoria y continuidad.

---

## 2. Fin específico del Monitor‑Termux Soberano V3

El Monitor‑Termux Soberano V3 es:

- el **panel de control visual** del Estado SODA‑NEXUS;  
- el **espejo global** del estado real de Termux;  
- la **interfaz pública** (GitHub Pages) que permite observar, auditar y entender el sistema desde cualquier dispositivo.

Su propósito es:

- mostrar el estado real de `~/soda/` (carpetas, archivos, logs, procesos);  
- permitir navegación estructurada (explorador de archivos);  
- permitir lectura segura de archivos;  
- permitir ejecución controlada de scripts autorizados;  
- exponer información al navegador sin exponer secretos;  
- servir como base para paneles futuros (economía, trading, bots, IA, auditoría).

El monitor es una **capa de observación, control y auditoría**, no de improvisación.

---

## 3. Contexto histórico del proyecto

1. Jeisson consolida todo en `~/soda/`, eliminando desorden y duplicados.  
2. Se define una estructura institucional con carpetas oficiales (SISTEMA, OPERACIONES, LOGS, DOCUMENTACION).  
3. Se redactan constituciones internas para evitar amnesia y garantizar continuidad.  
4. Se decide construir un monitor soberano accesible desde cualquier dispositivo.  
5. Se diseña una arquitectura por fases (7 fases), cada una con documento, scripts y pruebas.  
6. Se implementa el backend en Termux, luego el frontend, luego la publicación en GitHub Pages.  
7. Todo se alinea explícitamente con el objetivo de libertad financiera.

---

## 4. Fases del Monitor‑Termux Soberano V3

### 4.1. Fase 1 — Constitución del Monitor  
Define:

- propósito del monitor;  
- arquitectura;  
- pestañas;  
- endpoints;  
- seguridad;  
- auditoría;  
- relación con Termux.

Documento:  
`~/soda/06-DOCUMENTACION/MONITOR/FASE-1-CONSTITUCION.md`

---

### 4.2. Fase 2 — Backend Soberano  
Implementado con:

- Flask  
- Flask‑SocketIO  
- Eventlet  

Endpoints:

- `/estado`  
- `/carpetas`  
- `/archivo`  
- `/procesos`  
- `/logs`  
- `/scripts`  
- `/scripts/ejecutar`

Ruta backend:  
`~/soda/02-SISTEMA/BACKEND/MONITOR/`

---

### 4.3. Fase 3 — Frontend Soberano + Publicación  
- Frontend mínimo creado en `~/soda/docs/monitor/`.  
- Publicado en GitHub Pages bajo `/docs/monitor/`.  
- URL pública del monitor:  
  **https://jeengras1.github.io/finanzas-brillantes/monitor/**  
- Conexión al backend mediante `/estado`, `/carpetas`, `/archivo`.

---

### 4.4. Fases futuras

- **Fase 4 — IA Central:** análisis, diagnóstico, resumen de logs, overlay inteligente.  
- **Fase 5 — Auditoría y Seguridad:** hashes, integridad, validación de scripts.  
- **Fase 6 — Publicación avanzada:** automatización, túneles, estados de despliegue.  
- **Fase 7 — Expansión:** panel económico, trading, bots, comunicaciones.

---

## 5. Relación entre Termux y GitHub

### 5.1. Termux como núcleo soberano  
- Todo vive en `~/soda/`.  
- Ningún archivo se edita a mano.  
- Todo se genera con scripts (`cat << 'EOF'`).  
- Logs en `~/soda/05-LOGS/`.  
- Documentación en `~/soda/06-DOCUMENTACION/`.

### 5.2. GitHub como espejo público  
- GitHub Pages sirve la interfaz global del monitor.  
- URL raíz del sitio:  
  **https://jeengras1.github.io/finanzas-brillantes/**  
- El monitor vive en:  
  **https://jeengras1.github.io/finanzas-brillantes/monitor/**  
- Repositorio remoto:  
  `https://github.com/jeengras1/finanzas-brillantes.git`

### 5.3. Repositorio local relevante  
Detectado automáticamente:

`/data/data/com.termux/files/home/soda/99-TMP/snx_publish_monitor/repo`

Este repositorio:

- tiene `/docs/`;  
- contiene `/docs/monitor/`;  
- está vinculado a `finanzas-brillantes`.

---

## 6. Scripts institucionales del monitor

- `snx_detect_repos.sh` — detecta repositorios Git.  
- `snx_select_repo.sh` — selecciona el repositorio correcto.  
- `snx_publish_monitor.sh` — publica el monitor en GitHub Pages.  
- `snx_monitor_backend_run.sh` — ejecuta el backend Flask.

---

## 7. Observaciones institucionales

- No se asume nada: todo se detecta o se guarda explícitamente.  
- Nada se borra: cada fase se suma a la anterior.  
- Todo se documenta: cada fase produce un documento.  
- Todo se automatiza: no se usa nano.  
- GitHub es espejo, no origen.  
- El fin último es financiero: cada módulo debe contribuir a la libertad financiera.

---

## 8. Pies de página institucionales

**Pie 1 — Soberanía:** nada crítico depende de servicios externos opacos.  
**Pie 2 — Auditoría:** toda acción deja rastro en `05-LOGS`.  
**Pie 3 — Antiamnesia:** todo conocimiento estable va a `06-DOCUMENTACION`.  
**Pie 4 — Integridad:** los scripts no se editan a mano.  
**Pie 5 — Publicación:** el monitor global vive en `/docs/monitor/`.

---

## 9. Estado del documento

Este documento es la **fuente de verdad contextual** del Monitor‑Termux Soberano V3.  
Debe consultarse antes de cualquier modificación estructural, técnica o institucional.

