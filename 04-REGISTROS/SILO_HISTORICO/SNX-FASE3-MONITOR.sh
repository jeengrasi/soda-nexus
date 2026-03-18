#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# SODA‑NEXUS — FASE 3
# Monitor Soberano v2 (Modo Tor + Modo Local)
# Versión: 1.0 — Todo nuevo, nada se modifica
# ============================================================

MONITOR_DIR="$HOME/soda/06-MONITOR/V2"
LOG_DIR="$HOME/soda/05-LOGS/MONITOR"
VAULT="$HOME/soda/00-VAULT/SNX-TOR-ONION-V1.txt"

mkdir -p "$MONITOR_DIR"
mkdir -p "$LOG_DIR"

ONION_URL=$(cat "$VAULT" 2>/dev/null)

# ------------------------------------------------------------
# [OBS-01] Crear index-v2.html
# ------------------------------------------------------------
cat > "$MONITOR_DIR/index-v2.html" << EOF_HTML
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <title>SODA‑NEXUS — Monitor Soberano v2</title>
  <style>
    body { font-family: system-ui, sans-serif; background: #050816; color: #e5e7eb; margin: 0; padding: 1.5rem; }
    h1 { margin-top: 0; }
    .card { background: #0b1120; border-radius: 0.75rem; padding: 1rem 1.25rem; margin-bottom: 1rem; border: 1px solid #1f2937; }
    code { background: #020617; padding: 0.15rem 0.35rem; border-radius: 0.25rem; }
    button { background: #1d4ed8; color: white; border: none; padding: 0.5rem 0.9rem; border-radius: 0.5rem; cursor: pointer; }
    button:hover { background: #2563eb; }
    .row { display: flex; gap: 1rem; flex-wrap: wrap; }
    .row > div { flex: 1 1 260px; }
  </style>
</head>
<body>
  <h1>SODA‑NEXUS — Monitor Soberano v2</h1>

  <div class="card">
    <p><strong>Modo Local:</strong> <code>http://127.0.0.1:5051</code></p>
    <p><strong>Modo Tor:</strong> <code>${ONION_URL}</code></p>
    <button onclick="refreshAll()">Actualizar estado</button>
  </div>

  <div class="row">
    <div class="card">
      <h2>Estado backend</h2>
      <pre id="status-output">Sin datos…</pre>
    </div>
    <div class="card">
      <h2>Versión</h2>
      <pre id="version-output">Sin datos…</pre>
    </div>
  </div>

  <div class="card">
    <h2>Health</h2>
    <pre id="health-output">Sin datos…</pre>
  </div>

  <script src="./monitor-v2.js"></script>
</body>
</html>
EOF_HTML

# ------------------------------------------------------------
# [OBS-02] Crear monitor-v2.js
# ------------------------------------------------------------
cat > "$MONITOR_DIR/monitor-v2.js" << EOF_JS
// ============================================================
// Monitor Soberano v2 — Modo Local + Modo Tor
// ============================================================

const LOCAL = "http://127.0.0.1:5051";
const TOR = "http://${ONION_URL}";

async function fetchJSON(base, path) {
  try {
    const res = await fetch(base + path);
    if (!res.ok) throw new Error("HTTP " + res.status);
    return await res.json();
  } catch (err) {
    return { error: true, base, message: err.message };
  }
}

async function refreshStatus() {
  const el = document.getElementById("status-output");
  const local = await fetchJSON(LOCAL, "/status");
  if (!local.error) return el.textContent = JSON.stringify(local, null, 2);
  const tor = await fetchJSON(TOR, "/status");
  el.textContent = JSON.stringify(tor, null, 2);
}

async function refreshVersion() {
  const el = document.getElementById("version-output");
  const local = await fetchJSON(LOCAL, "/version");
  if (!local.error) return el.textContent = JSON.stringify(local, null, 2);
  const tor = await fetchJSON(TOR, "/version");
  el.textContent = JSON.stringify(tor, null, 2);
}

async function refreshHealth() {
  const el = document.getElementById("health-output");
  const local = await fetchJSON(LOCAL, "/health");
  if (!local.error) return el.textContent = JSON.stringify(local, null, 2);
  const tor = await fetchJSON(TOR, "/health");
  el.textContent = JSON.stringify(tor, null, 2);
}

async function refreshAll() {
  await Promise.all([refreshStatus(), refreshVersion(), refreshHealth()]);
}

window.addEventListener("load", refreshAll);
EOF_JS

# ------------------------------------------------------------
# [OBS-03] Registrar Fase 3
# ------------------------------------------------------------
echo "[FASE 3] Monitor Soberano v2 creado el $(date)" >> "$LOG_DIR/FASE3.log"

# ============================================================
# PIE INSTITUCIONAL — SODA‑NEXUS
# FASE 3: Monitor Soberano v2 (Tor + Local)
# No sobrescribe nada previo. Solo crea, nunca destruye.
# ============================================================
