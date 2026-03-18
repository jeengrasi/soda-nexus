#!/data/data/com.termux/files/usr/bin/python3
# ============================================================================
# SNX — ANTIAMNESIA ENDPOINT V1
# Exponer estado antiamnesia en /antiamnesia/estado (JSON).
# ============================================================================

import http.server
import socketserver
import subprocess
import json
import os

SODA = os.path.expanduser("~/soda")
SCRIPT = f"{SODA}/02-SCRIPTS/ANTIAMNESIA/snx_memoria_central_v2.sh"

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/antiamnesia/estado":
            try:
                out = subprocess.check_output([SCRIPT, "estado"], text=True)
                data = json.loads(out)
                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps(data).encode())
            except Exception as e:
                self.send_response(500)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps({
                    "error": "no_se_pudo_obtener_estado",
                    "detalle": str(e)
                }).encode())
            return
        self.send_response(404)
        self.end_headers()

PORT = 5054
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    httpd.serve_forever()

# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL — SNX‑2026‑B
# ============================================================================
