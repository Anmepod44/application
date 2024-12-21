from flask import Flask
import os

app = Flask(__name__)
MODULE_DIR = "/application/modules"

def load_modules():
    modules = []
    for item in os.listdir(MODULE_DIR):
        mod_path = os.path.join(MODULE_DIR, item)
        if os.path.isdir(mod_path) and os.path.exists(os.path.join(mod_path, 'module.py')):
            module_name = item
            try:
                module = __import__(f"modules.{module_name}.module", fromlist=['init_app'])
                if hasattr(module, 'init_app'):
                    module.init_app(app)
                    modules.append(module_name)
            except Exception as e:
                with open("/application/module_errors.log", "a") as log:
                    log.write(f"Failed to load module {module_name}: {e}\n")
    return modules

@app.route("/reload_modules")
def reload_modules():
    loaded = load_modules()
    return f"Modules reloaded: {loaded}"

@app.route("/")
def hello():
    return "Main Application Running - Modules Loaded."

if __name__ == "__main__":
    loaded = load_modules()
    print("Loaded Modules:", loaded)
    app.run(host="0.0.0.0", port=8080)
