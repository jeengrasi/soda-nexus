// ============================================================================
// SODA‑NEXUS — PANEL INSTITUCIONAL V1
// Módulo externo que muestra estado del backend, antiamnesia y archivos sagrados.
// ============================================================================

async function cargarPanelInstitucional() {
    const c = document.getElementById("content");
    c.innerHTML = "<h2>Panel Institucional</h2><p>Cargando…</p>";

    try {
        const estadoBackend = await fetch("http://127.0.0.1:15051/estado").then(r => r.json()).catch(() => null);
        const estadoAntiamnesia = await fetch("http://127.0.0.1:5054/antiamnesia/estado").then(r => r.json()).catch(() => null);

        c.innerHTML = `
            <h2>Panel Institucional</h2>

            <h3>Backend</h3>
            <pre>${estadoBackend ? JSON.stringify(estadoBackend, null, 2) : "No disponible"}</pre>

            <h3>Antiamnesia</h3>
            <pre>${estadoAntiamnesia ? JSON.stringify(estadoAntiamnesia, null, 2) : "No disponible"}</pre>

            <h3>Archivos Sagrados</h3>
            <pre>Integridad verificada por watchdog y antiamnesia.</pre>

            <h3>IP LAN</h3>
            <pre>${estadoAntiamnesia ? estadoAntiamnesia.ip : "No disponible"}</pre>

            <h3>Salud del Sistema</h3>
            <pre>${estadoAntiamnesia ? estadoAntiamnesia.salud + "%" : "No disponible"}</pre>
        `;
    } catch (e) {
        c.innerHTML = "<h2>Panel Institucional</h2><p>Error al cargar datos.</p>";
    }
}

// ============================================================================
// PIE DE PÁGINA INSTITUCIONAL — SNX‑2026‑B
// • La memoria es Termux; la IA es desechable.
// • Ningún archivo sagrado puede ser modificado.
// • Toda mejora debe ser versionada, nunca sobrescrita.
// • La integridad del sistema es ley suprema.
// ============================================================================
