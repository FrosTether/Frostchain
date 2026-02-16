import os
import subprocess
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/api/cli', methods=['POST'])
def handle_cli():
    data = request.json
    cmd = data.get('cmd')
    params = data.get('params', [])
    full_cmd = ["frostchain-cli", cmd] + params
    try:
        result = subprocess.run(full_cmd, capture_output=True, text=True)
        return jsonify({"status": "success", "output": result.stdout.strip()})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8082)
