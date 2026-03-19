#!/data/data/com.termux/files/usr/bin/python3
# ============================================================================
# SNX — FASE C
# Endpoint para exponer SNX-RESUMEN-ACTUAL.md
# ============================================================================

import http.server
import socketserver
import os

SODA = os.path.expanduser("~/soda")
RESUMEN = f"{SODA}/01-MEMORIA/SNX-RESUMEN-ACTUAL.md"

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/memoria/resumen":
            if not os.path.exists(RESUMEN):
                self.send_response(404)
                self.end_headers()
                self.wfile.write(b"Resumen no generado.")
                return
            with open(RESUMEN, "r") as f:
                data = f.read().encode()
            self.send_response(200)
            self.send_header("Content-Type", "text/plain; charset=utf-8")
            self.end_headers()
            self.wfile.write(data)
            return
        self.send_response(404)
        self.end_headers()

PORT = 5053
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    httpd.serve_forever()

# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL — SNX‑2026‑B
# ============================================================================
