import os, json, time

LOG_DIR = os.path.expanduser("~/soda/05-LOGS/MONITOR/")
os.makedirs(LOG_DIR, exist_ok=True)

def audit(event_type, data):
    entry = {
        "timestamp": time.time(),
        "event": event_type,
        "data": data
    }
    path = os.path.join(LOG_DIR, "monitor_audit.jsonl")
    with open(path, "a") as f:
        f.write(json.dumps(entry) + "\n")
