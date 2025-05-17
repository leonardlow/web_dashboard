from flask import Flask, request
import subprocess

app = Flask(__name__)

@app.route('/start-flask', methods=['POST'])
def start_flask():
    subprocess.Popen(['python', r'C:\Checkpoint Build\run_kchow_flask_apps.py'])
    return "Flask app started!"

if __name__ == '__main__':
    app.run(debug=True)
