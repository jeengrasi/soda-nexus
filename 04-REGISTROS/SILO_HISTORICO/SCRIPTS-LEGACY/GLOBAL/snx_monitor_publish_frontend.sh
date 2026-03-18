#!/usr/bin/env bash
set -e

echo "=== SODA-NEXUS :: PUBLICAR FRONTEND DEL MONITOR EN /docs/monitor/ ==="

read -p "Ruta local del repositorio (ej: /data/data/com.termux/files/home/soda/REPOS/finanzas-brillantes): " REPO_DIR

if [ -z "$REPO_DIR" ] || [ ! -d "$REPO_DIR/.git" ]; then
  echo "Repositorio inválido. Abortando."
  exit 1
fi

DOCS_DIR="$REPO_DIR/docs/monitor"
mkdir -p "$DOCS_DIR"

cat > "$DOCS_DIR/index.html" << 'HTML'
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Monitor-Termux Soberano V3</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body { background:#020617; color:#e5e7eb; font-family: system-ui, sans-serif; margin:0; padding:0; }
    header { padding:1rem; border-bottom:1px solid #1f2937; display:flex; justify-content:space-between; align-items:center; }
    .status-online { color:#22c55e; }
    .status-offline { color:#ef4444; }
    main { display:flex; height:calc(100vh - 56px); }
    .sidebar { width:30%; border-right:1px solid #1f2937; padding:1rem; overflow:auto; }
    .content { flex:1; padding:1rem; overflow:auto; }
    ul { list-style:none; padding-left:0; }
    li { cursor:pointer; padding:2px 0; }
    li span.type-dir { color:#38bdf8; }
    li span.type-file { color:#e5e7eb; }
    pre { background:#020617; border:1px solid #1f2937; padding:0.5rem; white-space:pre-wrap; }
    small { color:#9ca3af; }
  </style>
</head>
<body>
  <header>
    <div>
      <strong>Monitor-Termux Soberano V3</strong><br>
      <small id="timestamp">Sin conexión aún</small>
    </div>
    <div id="status" class="status-offline">● OFFLINE</div>
  </header>
  <main>
    <section class="sidebar">
      <h3>Explorador de archivos</h3>
      <div>
        <small>Ruta relativa a ~/soda/:</small><br>
        <input id="path-input" type="text" value="" style="width:100%;margin:4px 0;">
        <button id="load-path">Cargar</button>
      </div>
      <ul id="file-list"></ul>
    </section>
    <section class="content">
      <h3>Contenido</h3>
      <div id="file-path"></div>
      <pre id="file-content">Selecciona un archivo para ver su contenido.</pre>
    </section>
  </main>
  <script src="monitor.js"></script>
</body>
</html>
HTML

cat > "$DOCS_DIR/monitor.js" << 'JS'
const backendBase = "http://127.0.0.1:5051";

const statusEl = document.getElementById("status");
const tsEl = document.getElementById("timestamp");
const pathInput = document.getElementById("path-input");
const loadBtn = document.getElementById("load-path");
const fileList = document.getElementById("file-list");
const filePathEl = document.getElementById("file-path");
const fileContentEl = document.getElementById("file-content");

async function checkEstado() {
  try {
    const res = await fetch(backendBase + "/estado");
    if (!res.ok) throw new Error("Estado no OK");
    const data = await res.json();
    statusEl.textContent = "● ONLINE";
    statusEl.className = "status-online";
    const date = new Date(data.timestamp * 1000);
    tsEl.textContent = "Último latido: " + date.toLocaleString();
  } catch (e) {
    statusEl.textContent = "● OFFLINE";
    statusEl.className = "status-offline";
    tsEl.textContent = "Sin conexión al backend";
  }
}

async function loadPath(path) {
  try {
    const res = await fetch(backendBase + "/carpetas?path=" + encodeURIComponent(path));
    if (!res.ok) throw new Error("Error al listar");
    const data = await res.json();
    fileList.innerHTML = "";
    (data.items || []).forEach(item => {
      const li = document.createElement("li");
      const span = document.createElement("span");
      span.textContent = item.name;
      span.className = item.type === "dir" ? "type-dir" : "type-file";
      li.appendChild(span);
      li.addEventListener("click", () => {
        if (item.type === "dir") {
          const newPath = (path ? path + "/" : "") + item.name;
          pathInput.value = newPath;
          loadPath(newPath);
        } else {
          const filePath = (path ? path + "/" : "") + item.name;
          loadFile(filePath);
        }
      });
      fileList.appendChild(li);
    });
  } catch (e) {
    fileList.innerHTML = "<li>Error al cargar ruta</li>";
  }
}

async function loadFile(path) {
  try {
    const res = await fetch(backendBase + "/archivo?path=" + encodeURIComponent(path));
    if (!res.ok) throw new Error("Error al leer archivo");
    const data = await res.json();
    filePathEl.textContent = "Archivo: " + path;
    fileContentEl.textContent = data.content;
  } catch (e) {
    filePathEl.textContent = "Archivo: " + path;
    fileContentEl.textContent = "Error al leer archivo.";
  }
}

loadBtn.addEventListener("click", () => {
  loadPath(pathInput.value.trim());
});

checkEstado();
setInterval(checkEstado, 10000);
loadPath("");
JS

cd "$REPO_DIR"
git add docs/monitor/index.html docs/monitor/monitor.js || true

echo "=== Archivos del monitor preparados en $REPO_DIR/docs/monitor/ ==="
echo "Revisa con: git status"
echo "Cuando estés listo, ejecuta: git commit -m \"Monitor-Termux V3 - Frontend mínimo\" && git push"
