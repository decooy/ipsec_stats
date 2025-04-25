from flask import Flask
import subprocess

app = Flask(__name__)

@app.route('/')
def index():
    return ''

@app.route('/connected')
def get_ipsec_connections():
    try:
        # Run the command and capture output
        result = subprocess.run(
            "ipsec --status | grep -E '^Total IPsec connections:' | awk '{print $7}'",
            shell=True,
            capture_output=True,
            text=True
        )
        return result.stdout.strip()
    except Exception as e:
        return str(e), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
