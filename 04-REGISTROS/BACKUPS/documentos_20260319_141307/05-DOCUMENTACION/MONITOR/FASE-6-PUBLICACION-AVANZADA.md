# FASE 6 — PUBLICACIÓN AVANZADA Y ESTADO DEL DESPLIEGUE  
Fecha: 2026-03-04  
Estado: ACTIVO

## 1. Propósito
Garantizar que la publicación del monitor en GitHub Pages sea:
- verificable,
- auditable,
- reproducible,
- sin suposiciones,
- con estado claro del despliegue.

## 2. Componentes
- Módulo `deploy_engine.py`
- Endpoint `/deploy/estado`
- Script `snx_deploy_estado.sh`

## 3. Qué verifica esta fase
- existencia de `/docs/index.html` en el repositorio local,
- existencia de `/docs/monitor.js` y `/docs/ia.js`,
- existencia de `.git`,
- existencia de `origin` remoto,
- si hay commits pendientes (`git status --porcelain`),
- si la última publicación coincide con el último commit.

## 4. Resultado esperado
Un JSON con:
- `archivos_publicacion`
- `git_remoto`
- `git_pendientes`
- `estado_publicacion`
- `timestamp`

## 5. Observaciones
- No publica nada.
- No hace push.
- Solo informa el estado real del despliegue.

