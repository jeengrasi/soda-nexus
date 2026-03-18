import os, sys

BASE = os.path.expanduser("~/soda/02-SISTEMA/BACKEND/MONITOR")
sys.path.insert(0, BASE)

import snx_monitor_backend

if __name__ == "__main__":
    snx_monitor_backend.socketio.run(
        snx_monitor_backend.app,
        host="0.0.0.0",
        port=5052
    )
