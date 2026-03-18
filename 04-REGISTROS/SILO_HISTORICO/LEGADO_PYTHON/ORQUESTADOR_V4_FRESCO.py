from flask import Flask, jsonify, send_from_directory
from flask_cors import CORS
import json, os

app = Flask(__name__)
CORS(app)

BASE_DIR = os.path.expanduser('~/soda')
STATIC_DIR = os.path.join(BASE_DIR, '03-OPERACIONES/WEB/MONITOR_V4_FRESCO')
DATA_FILE = os.path.join(BASE_DIR, '06-MONITOR/V3/monitor_data.json')

@app.route('/')
def index():
    return send_from_directory(STATIC_DIR, 'index.html')

@app.route('/api/data')
def get_data():
    if not os.path.exists(DATA_FILE):
        return jsonify({"status": "error", "message": "Esperando datos..."}), 202
    with open(DATA_FILE, 'r') as f:
        return jsonify(json.load(f))

@app.route('/<path:path>')
def static_files(path):
    return send_from_directory(STATIC_DIR, path)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=15051, debug=False)
