/* ============================================================
   SODA‑NEXUS — Módulo de Logs (versión estática)
   Lee logs desde monitor_data.json (no desde backend)
   ============================================================ */

async function cargarLogs() {
    const container = document.getElementById("snx-logs");
    if (!container) return;
    
    try {
        const response = await fetch('monitor_data.json');
        const data = await response.json();
        
        // Mostrar información relevante como logs
        container.innerHTML = `
            <div class="log-line log-info">🟢 Sistema activo</div>
            <div class="log-line log-info">📅 Última actualización: ${data.timestamp || "—"}</div>
            <div class="log-line log-info">🔧 Backend: ${data.backend || "—"}</div>
            <div class="log-line log-info">📊 Scripts unificados: ${data.scripts_unificados?.length || 0}</div>
            <div class="log-line log-info">🏛️ Ministerios: ${Object.keys(data.ministerios || {}).length}</div>
        `;
    } catch (error) {
        container.innerHTML = `<div class="log-line log-error">Error cargando logs: ${error.message}</div>`;
    }
}

// Cargar al iniciar
cargarLogs();

// Actualizar cada 30 segundos (por si hay nueva versión)
setInterval(cargarLogs, 30000);
