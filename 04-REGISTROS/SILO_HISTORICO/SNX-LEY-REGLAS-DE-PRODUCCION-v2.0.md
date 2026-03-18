# SNX-LEY-REGLAS-DE-PRODUCCION  
## Ley institucional para la generación, entrega, archivo y protección documental en SODA‑NEXUS  
Versión 2.0 — Estado Soberano

---

## 1. Propósito de esta Ley
Establecer las reglas absolutas que rigen la creación, entrega, almacenamiento y preservación de documentos, scripts y contenido institucional dentro de SODA‑NEXUS, garantizando:

- orden estructural,  
- continuidad lógica,  
- resistencia a la amnesia de IA,  
- claridad operativa,  
- portabilidad entre IAs y Termux,  
- y máxima eficiencia en un solo chat.

---

## 2. Regla del Documento en Markdown (obligatorio)
Todo documento generado por cualquier IA debe entregarse **siempre** dentro de un bloque Markdown:

```markdown
# Documento
Contenido...

mkdir -p ~/soda/05-DOCUMENTACION/
cat > ~/soda/05-DOCUMENTACION/NOMBRE_DEL_DOCUMENTO.md << 'EOF'
[DOCUMENTO COMPLETO]
