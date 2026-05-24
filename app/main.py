from flask import Flask, jsonify
import socket
import os

app = Flask(__name__)

@app.route("/")
def index():
    pod_ip = socket.gethostbyname(socket.gethostname())
    pod_name = os.environ.get("POD_NAME", "unknown")
    return jsonify({
        "status": "ok",
        "message": "Hello from DevOps Final Project!",
        "pod_ip": pod_ip,
        "pod_name": pod_name
    }), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)