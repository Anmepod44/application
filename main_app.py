from flask import Flask,request, jsonify
import os

app = Flask(__name__)

# Root route
@app.route('/')
def home():
    return "Welcome to the Advanced Automated Dashboard!"

# List all modules
@app.route('/modules', methods=['GET'])
def list_modules():
    modules_path = os.path.join(os.getcwd(), 'modules')
    installed_modules = os.listdir(modules_path) if os.path.exists(modules_path) else []
    return jsonify({"installed_modules": installed_modules})

# Install a new module
@app.route('/modules/install', methods=['POST'])
def install_module():
    module_name = request.json.get('module_name')
    if not module_name:
        return jsonify({"error": "Module name is required"}), 400
    
    modules_path = os.path.join(os.getcwd(), 'modules')
    os.makedirs(modules_path, exist_ok=True)
    module_path = os.path.join(modules_path, module_name)
    
    if os.path.exists(module_path):
        return jsonify({"error": "Module already exists"}), 400
    
    os.makedirs(module_path)
    return jsonify({"message": f"Module {module_name} installed successfully."})

# System status
@app.route('/status', methods=['GET'])
def status():
    return jsonify({
        "server": "running",
        "modules": os.listdir(os.path.join(os.getcwd(), 'modules')) if os.path.exists(os.path.join(os.getcwd(), 'modules')) else []
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)