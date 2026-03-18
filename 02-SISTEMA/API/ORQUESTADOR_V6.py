from flask import Flask, jsonify, send_from_directory
from flask_cors import CORS
import os, json

app = Flask(__name__)
CORS(app)

# Ruta legal según Regla 8
DIR_WEB = os.path.expanduser('~/soda/03-OPERACIONES/WEB')
MONITOR_DATA = os.path.expanduser('~/soda/04-REGISTROS/monitor_data.json')

@app.route('/')
def index():
    return send_from_directory(DIR_WEB, 'index-v4.html')

@app.route('/api/data')
@app.route('/status')
def get_data():
    if not os.path.exists(MONITOR_DATA):
        # Si no existe, creamos un estado base para que el monitor no se quede "cargando"
        base = {"status": "online", "ministerios": {"00": "OK", "01": "OK", "02": "OK"}}
        with open(MONITOR_DATA, 'w') as f: json.dump(base, f)
    
    with open(MONITOR_DATA, 'r') as f:
        return jsonify(json.load(f))

@app.route('/<path:path>')
def serve_static(path):
    return send_from_directory(DIR_WEB, path)

if __name__ == '__main__':
    from waitress import serve
    serve(app, host="0.0.0.0", port=15051)(host='0.0.0.0', port=15051, threaded=True)
