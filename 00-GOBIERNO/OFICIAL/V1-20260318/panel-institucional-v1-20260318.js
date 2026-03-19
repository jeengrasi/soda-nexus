/* ============================================================
   SODA-NEXUS — Panel Institucional V4
   Extensión que permite ver estado del backend y antiamnesia.
   No modifica archivos sagrados ni versiones previas.
   ============================================================ */

const API_PANEL_V4 = window.SNX_BACKEND_URL_V4;

/* OBS: Inserta botón en la toolbar del monitor V4. */
window.addEventListener("load", () => {
    const toolbar = document.getElementById("snx-toolbar");
    if (!toolbar) return;

    const btn = document.createElement("button");
    btn.innerText = "Panel Institucional";
    btn.onclick = snx_v4_cargarPanelInstitucional;
    toolbar.appendChild(btn);
});

/* OBS: Carga datos institucionales en un modal simple (reutiliza panel de estado global). */
async function snx_v4_cargarPanelInstitucional() {
    const detalles = [];

    try {
        const estadoBackend = await fetch(`${API_PANEL_V4}/status`).then(r => r.json());
        detalles.push("=== BACKEND /status ===");
        detalles.push(JSON.stringify(estadoBackend, null, 2));
    } catch (e) {
        detalles.push("ERROR al obtener /status: " + e.message);
    }

    try {
        const anti = await fetch(`${API_PANEL_V4}/antiamnesia/estado`).then(r => r.json());
        detalles.push("=== ANTIAMNESIA /antiamnesia/estado ===");
        detalles.push(JSON.stringify(anti, null, 2));
    } catch (e) {
        detalles.push("ERROR al obtener /antiamnesia/estado: " + e.message);
    }

    alert(detalles.join("\n\n"));
}

/* ============================================================
   PIE DE PÁGINA INSTITUCIONAL — SODA-NEXUS
   Este archivo pertenece al sistema soberano SODA-NEXUS.
   REGLAS INSTITUCIONALES:
   1. Las instrucciones deben darse SIEMPRE en orden y completas.
   2. No se deben modificar líneas sin aprobación institucional.
   3. Si un script existe en el sistema, debe solicitarse, leerse
      y modificarse únicamente sobre su contenido real.
   4. No mover, eliminar o sobrescribir archivos sin inspección
      previa del filesystem para evitar pérdida de memoria.
   5. Cada script o documento debe incluir encabezado, observaciones
      por línea y este pie de página institucional.
   6. Mantener coherencia con la estructura soberana del Estado.
   7. Garantizar anti-amnesia y auditabilidad total.
   8. Realizar la mayoría de tareas en un solo chat para preservar
      el contexto operativo y la memoria institucional.
   ============================================================ */
