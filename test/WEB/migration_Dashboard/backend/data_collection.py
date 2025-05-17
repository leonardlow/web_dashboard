import json
import subprocess
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/', methods=['POST'])
def collect_data():
    input_data = request.json
    old_ipv4 = input_data['old_ipv4']
    old_ipv6 = input_data['old_ipv6']
    new_ipv4 = input_data['new_ipv4']
    new_ipv6 = input_data['new_ipv6']

    data = {
        "old_pair": {
            "active_unit": subprocess.getoutput(f"ssh admin@{old_ipv4} 'fw ctl pstat'"),
            "chassis_platform": subprocess.getoutput(f"ssh admin@{old_ipv4} 'show asset all'"),
            "installed_policy": subprocess.getoutput(f"ssh admin@{old_ipv4} 'fw stat'"),
            "active_connections": subprocess.getoutput(f"ssh admin@{old_ipv4} 'fw tab -t connections -s'"),
            "ping_ipv4": subprocess.getoutput(f"ping -c 4 {old_ipv4}"),
            "ping_ipv6": subprocess.getoutput(f"ping6 -c 4 {old_ipv6}")
        },
        "new_pair": {
            "active_unit": subprocess.getoutput(f"ssh admin@{new_ipv4} 'fw ctl pstat'"),
            "chassis_platform": subprocess.getoutput(f"ssh admin@{new_ipv4} 'show asset all'"),
            "installed_policy": subprocess.getoutput(f"ssh admin@{new_ipv4} 'fw stat'"),
            "active_connections": subprocess.getoutput(f"ssh admin@{new_ipv4} 'fw tab -t connections -s'"),
            "ping_ipv4": subprocess.getoutput(f"ping -c 4 {new_ipv4}"),
            "ping_ipv6": subprocess.getoutput(f"ping6 -c 4 {new_ipv6}")
        }
    }

    with open('backend/firewall_data.json', 'w') as outfile:
        json.dump(data, outfile, indent=4)

    return jsonify(data)

if __name__ == "__main__":
    app.run(debug=True)
