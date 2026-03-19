# SNX — HOJA DE RUTA INSTITUCIONAL 2026  
Documento guía oficial para la construcción del Monitor, IA‑SCRIPT CENTRAL, guardianes derivados y el sistema inmune de SODA‑NEXUS.

---

## 1. Propósito del documento
Este documento define la arquitectura, fases, dependencias y secuencia oficial de construcción del sistema inmune de SODA‑NEXUS. Es el plano maestro que guía todas las decisiones técnicas y estructurales.

---

## 2. Estado actual del sistema (basado en inspección real)
- La estructura soberana existe y está limpia:  
  00‑GOBIERNO, 01‑MEMORIA, 02‑SISTEMA, 03‑OPERACIONES, 04‑REGISTROS, 05‑DOCUMENTACION, 99‑TMP.
- El backend del monitor ya está vivo en `/folders`.
- La WebApp existe pero sin monitor.
- Existen scripts viejos que apuntan a rutas fantasma (ej. 02‑SCRIPTS).
- No existen aún:
  - IA‑SCRIPT CENTRAL  
  - IA‑SCRIPTS derivados  
  - Clasificación institucional  
  - Alertas  
  - Monitor visual  
  - Auditoría automática  
  - Sistema antiamnesia  

El sistema funciona, pero no se gobierna a sí mismo.

---

## 3. Arquitectura institucional (visión completa)
SODA‑NEXUS requiere cuatro capas engranadas:

### 3.1 Capa 1 — Motor del Monitor (backend)
- Lee el filesystem real.
- Expone rutas como `/folders`.
- Es la memoria viva del sistema.  
**Estado:** Completado.

### 3.2 Capa 2 — Inteligencia Institucional (clasificación + auditoría)
El backend debe clasificar:
- oficial  
- crítica  
- sospechosa  
- vacía  
- fantasma  
- ruido  

Y detectar:
- rutas rotas  
- scripts viejos  
- carpetas fuera de norma  
- carpetas inesperadas  
- carpetas vacías críticas  

**Estado:** Próxima fase.

### 3.3 Capa 3 — Monitor Visual (WebApp)
La pantalla del monitor debe mostrar:
- árbol de carpetas  
- colores por estado  
- alertas  
- carpetas fantasma  
- rutas rotas  
- archivos sospechosos  
- estado institucional  
- logs en vivo  

**Estado:** pendiente de Fase 2.

### 3.4 Capa 4 — IA‑SCRIPT CENTRAL
El cerebro institucional:
- valida VAULT  
- valida ESTADO  
- valida permisos  
- coordina guardianes  
- actualiza snx_state.json  
- genera alertas  
- registra decisiones  

**Estado:** pendiente de Fase 3.

### 3.5 Capa 5 — IA‑SCRIPTS DERIVADOS (guardianes)
Cada carpeta soberana tiene su guardián:
- guardian_gobierno  
- guardian_memoria  
- guardian_sistema  
- guardian_operaciones  
- guardian_registros  
- guardian_docs  
- guardian_tmp  

Cada guardián sabe:
- qué archivos deben existir  
- qué archivos no deben existir  
- qué cambios deben alertarse  

**Estado:** pendiente de Fase 4.

---

## 4. Hoja de ruta oficial (fases secuenciales)

### FASE 1 — Motor del Monitor (backend)  
Estado: Completada.

### FASE 2 — Clasificación institucional + detección de anomalías  
El backend se convierte en un auditor:
- clasifica carpetas  
- detecta carpetas fantasma  
- detecta rutas rotas  
- detecta scripts viejos  
- detecta ruido  
- detecta inconsistencias  
- prepara la pantalla visual  
- prepara IA‑SCRIPT CENTRAL  

### FASE 3 — Monitor Visual (WebApp)  
La pantalla del monitor:
- árbol de carpetas  
- colores por estado  
- alertas  
- estado institucional  
- logs  
- auditoría visual  

### FASE 4 — IA‑SCRIPT CENTRAL  
El cerebro institucional:
- coordina guardianes  
- valida VAULT  
- valida ESTADO  
- valida permisos  
- genera alertas  
- registra decisiones  

### FASE 5 — IA‑SCRIPTS DERIVADOS (guardianes)  
Sensores locales por carpeta:
- detectan cambios  
- detectan ruido  
- detectan archivos sospechosos  
- protegen carpetas críticas  

### FASE 6 — Engranaje completo  
El sistema se vuelve:
- inmune  
- autoauditado  
- autoconsciente  
- antiamnesia  
- estable  
- soberano  

---

## 5. Reglas institucionales del documento
- Es la guía oficial.  
- Se actualiza solo por fases.  
- Se consulta antes de crear cualquier módulo.  
- Se consulta antes de escribir cualquier script.  
- Se consulta antes de modificar cualquier carpeta.  

---

## 6. Próximo paso inmediato
FASE 2 — Clasificación institucional + detección de carpetas fantasma.  
Esta fase es crítica para revelar rutas rotas, scripts viejos, carpetas inexistentes, ruido y preparar la pantalla y la IA‑SCRIPT CENTRAL.
