# ============================================================
# SODA‑NEXUS — Instructivo institucional para guardar documentos en Termux
# Documento oficial que define el proceso soberano para guardar,
# archivar y mantener la memoria institucional dentro de Termux.
# ============================================================

## 1. Propósito del instructivo
Este instructivo define el proceso correcto, ordenado y soberano para guardar
documentos, scripts y configuraciones dentro de Termux, garantizando:

- continuidad institucional
- antiamnesia
- auditabilidad total
- coherencia con la estructura soberana del Estado
- preservación de la memoria histórica del sistema

# OBS: Este documento define el estándar oficial para guardar archivos en Termux.
# OBS: No debe ser modificado sin aprobación institucional.
# OBS: Mantiene la coherencia documental del Estado Soberano SODA‑NEXUS.

---

## 2. Regla soberana: trabajar en un solo chat
Para evitar pérdida de contexto, contradicciones o amnesia:

- todas las tareas deben realizarse en un solo chat siempre que sea posible
- todas las instrucciones deben darse en orden y completas
- no se deben fragmentar procesos entre múltiples conversaciones
- el chat activo es el hilo institucional vigente

# OBS: Esta regla garantiza continuidad y evita fragmentación del Estado.
# OBS: Mantener la mayoría de tareas en un solo chat preserva la memoria operativa.
# OBS: Esta regla aplica a documentación, scripts y decisiones institucionales.

---

## 3. Proceso institucional para guardar un archivo en Termux

### Paso 1 — Crear el archivo con `cat`
Ejecutar en Termux:

cat > ~/soda/05-DOCUMENTACION/<nombre_del_documento>.md << 'EOF_DOC'
<contenido_del_documento>
EOF_DOC

# OBS: `cat` garantiza creación limpia y auditable del archivo.
# OBS: Nunca usar editores interactivos (nano, vim) para cambios institucionales.
# OBS: La ruta debe existir previamente; no crear carpetas nuevas sin aprobación.

---

### Paso 2 — Verificar que el archivo existe

ls -l ~/soda/05-DOCUMENTACION/

# OBS: Verificar existencia evita sobrescrituras accidentales.
# OBS: Este paso es obligatorio antes de modificar cualquier documento.

---

### Paso 3 — Leer el archivo para confirmar su contenido

cat ~/soda/05-DOCUMENTACION/<nombre_del_documento>.md

# OBS: Siempre leer antes de modificar; nunca modificar a ciegas.
# OBS: Este paso protege la memoria institucional ya escrita.

---

### Paso 4 — Modificar un archivo existente (si aplica)

cat > ~/soda/05-DOCUMENTACION/<nombre_del_documento>.md << 'EOF_DOC'
<nuevo_contenido_actualizado>
EOF_DOC

# OBS: Solo modificar después de leer el contenido real del archivo.
# OBS: Mantener encabezado, observaciones y pie de página intactos.
# OBS: No eliminar secciones sin justificación institucional explícita.

---

## 4. Reglas institucionales para todos los documentos

1. Las instrucciones deben darse siempre en orden y completas.
2. No modificar líneas sin aprobación institucional.
3. Si un script o documento existe, debe solicitarse, leerse y modificarse
   únicamente sobre su contenido real.
4. No mover, eliminar o sobrescribir archivos sin inspección previa del filesystem.
5. Cada documento debe incluir encabezado, observaciones por línea y pie de página.
6. Mantener coherencia con la estructura soberana del Estado.
7. Garantizar antiamnesia y auditabilidad total.
8. Realizar la mayoría de tareas en un solo chat para preservar el contexto.

# OBS: Estas reglas son obligatorias para todos los módulos del sistema.
# OBS: Su incumplimiento puede causar pérdida de memoria institucional.
# OBS: Este instructivo debe consultarse antes de crear o modificar archivos.

---

# ============================================================
# PIE DE PÁGINA INSTITUCIONAL — SODA‑NEXUS
# Este documento pertenece al sistema soberano SODA‑NEXUS.
# REGLAS INSTITUCIONALES:
# 1. Las instrucciones deben darse SIEMPRE en orden y completas.
# 2. No se deben modificar líneas sin aprobación institucional.
# 3. Si un script existe en el sistema, debe solicitarse, leerse
#    y modificarse únicamente sobre su contenido real.
# 4. No mover, eliminar o sobrescribir archivos sin inspección
#    previa del filesystem para evitar pérdida de memoria.
# 5. Cada script o documento debe incluir encabezado, observaciones
#    por línea y este pie de página institucional.
# 6. Mantener coherencia con la estructura soberana del Estado.
# 7. Garantizar anti‑amnesia y auditabilidad total.
# 8. Realizar la mayoría de tareas en un solo chat para preservar
#    el contexto operativo y la memoria institucional.
# ============================================================
