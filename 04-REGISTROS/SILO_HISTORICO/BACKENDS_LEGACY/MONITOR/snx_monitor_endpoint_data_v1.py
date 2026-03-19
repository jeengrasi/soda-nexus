#!/data/data/com.termux/files/usr/bin/python3
# ============================================================================
# SNX — FASE 6.1
# Endpoint independiente para exponer monitor_data.json
# No modifica el backend original. Servicio paralelo.
# ============================================================================

import http.server
import socketserver
import json
import os

SODA = os.path.expanduser("~/soda")
MONITOR_DATA = f"{SODA}/06-MONITOR/V3/monitor_data.json"

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/monitor/data":
            if not os.path.exists(MONITOR_DATA):
                self.send_response(404)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(b'{"status":"error","message":"monitor_data.json no encontrado"}')
                return

            with open(MONITOR_DATA, "r") as f:
                data = f.read().encode()

            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(data)
            return

        self.send_response(404)
        self.end_headers()

PORT = 5052
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    httpd.serve_forever()

# ============================================================================
# PIE DE PÁGINA INSTITUCIONAL — SNX‑2026‑B
# ============================================================================
