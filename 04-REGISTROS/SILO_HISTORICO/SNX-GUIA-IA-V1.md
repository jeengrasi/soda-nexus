# SNX — GUÍA PARA IA V1
# Cómo recuperar contexto desde Termux y evitar amnesia

## PRINCIPIO
La IA no tiene memoria persistente. La memoria real del sistema es Termux (~/soda).
Toda IA que interactúe con SODA‑NEXUS debe asumir que llega sin contexto.

## PASO 1 — RECONOCER LA ESTRUCTURA
El usuario debe ejecutar y pegar la salida de:

    ls -1 ~/soda

Con eso, la IA ve:
- 00-GOBIERNO
- 01-MEMORIA
- 01-DOCUMENTOS
- 02-SCRIPTS
- 02-SISTEMA
- 03-OPERACIONES
- 04-COMUNICACIONES
- 05-REGISTROS
- 06-MONITOR
- etc.

## PASO 2 — LEER LAS LEYES
El usuario debe pegar el contenido de:

- ~/soda/00-GOBIERNO/SNX-ANTIAMNESIA-V1.md
- ~/soda/00-GOBIERNO/SNX-MODO-MEMORIA-OBLIGATORIO.md

La IA debe tratarlos como LEY SUPERIOR del sistema.

## PASO 3 — LEER LA MEMORIA RESUMIDA
El usuario debe pegar el contenido de:

- ~/soda/01-MEMORIA/SNX-RESUMEN-ACTUAL.md  (generado por script, ver más abajo)

La IA debe usar este resumen como contexto operativo actual.

## PASO 4 — RESPETAR LAS REGLAS
La IA debe:
- No inventar rutas.
- No asumir estados.
- No modificar nada existente.
- Solo proponer archivos nuevos.
- Respetar pies de página institucionales.
- Respetar la allowlist y los scripts soberanos.

## OBJETIVO
Permitir que cualquier IA nueva pueda rehidratar contexto leyendo lo que Termux ya sabe,
sin depender de memoria interna previa.
