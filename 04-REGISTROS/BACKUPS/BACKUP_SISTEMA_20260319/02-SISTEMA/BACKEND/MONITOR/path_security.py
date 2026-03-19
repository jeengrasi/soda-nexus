import os

ALLOWED_BASE = os.path.expanduser("~/soda")
BLOCKED = ["00-GOBIERNO/VAULT", ".env", ".token", ".shadow"]

def is_safe(path):
    real = os.path.realpath(path)
    base = os.path.realpath(ALLOWED_BASE)
    if not real.startswith(base):
        return False
    for b in BLOCKED:
        if b in real:
            return False
    return True
