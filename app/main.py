from flask import Flask, request, Response
from datetime import datetime
import json

app = Flask(__name__)

@app.route('/')
def time_service():
    current_time = datetime.utcnow().isoformat() + "Z"
    client_ip = request.headers.get('X-Forwarded-For', request.remote_addr)

    response_data = {
        "timestamp": current_time,
        "ip": client_ip
    }

    json_response = json.dumps(response_data, indent=2)  # Pretty-printed JSON
    return Response(json_response, mimetype='application/json')  # Return as JSON

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
