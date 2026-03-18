from flask import Flask, jsonify, send_from_directory
from flask_cors import CORS
import os, json

app = Flask(__name__)
CORS(app)

DIR_ACTUAL = os.path.dirname(os.path.abspath(__file__))
MONITOR_DATA = os.path.expanduser('~/soda/06-MONITOR/V3/monitor_data.json')

@app.route('/')
def index():
    return send_from_directory(DIR_ACTUAL, 'index-v4.html')

@app.route('/api/data')
@app.route('/status')
def get_data():
    try:
        with open(MONITOR_DATA, 'r') as f:
            return jsonify(json.load(f))
    except Exception as e:
        return jsonify({"status": "error", "msg": str(e)}), 500

@app.route('/<path:path>')
def serve_static(path):
    return send_from_directory(DIR_ACTUAL, path)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=15051, ssl_context=('cert.pem', 'key.pem'), threaded=True)
