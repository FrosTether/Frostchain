import os
import subprocess
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
# Enable CORS for all Surge domains to stop the "Offline" error
CORS(app, resources={r"/api/*": {"origins": "*"}})

@app.route('/api/cli', methods=['POST'])
def handle_cli():
    data = request.json
    # Using the sign command you provided
    raw_hex = "eyJmcm9tIjoiZHJmcm9zdC5mcm9zdGNoYWluIiwidG8iOiJLZWxzZWVNLmZyb3N0Y2hhaW4iLCJhbW91bnRzIjp7IkZUQyI6MjAwMDAwLCJGTlIiOjQwMDAwLCJGUlNUIjozMTAwMDAwfSwidGltZXN0YW1wIjoxNzcwODc2MzM2MTYxLCJub25jZSI6MzY3MDd9"
    
    # Force the exact broadcast command you need
    full_cmd = ["frostchain-cli", "sendrawtransaction", raw_hex]
    
    try:
        print(f"[*] Broadcasting Airdrop to KelseeM...")
        result = subprocess.run(full_cmd, capture_output=True, text=True)
        return jsonify({"status": "success", "output": result.stdout.strip()})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

if __name__ == '__main__':
    # Binding to 127.0.0.1 for local device security
    app.run(host='127.0.0.1', port=8082)
