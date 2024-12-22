
from flask import Flask, render_template
import os

app = Flask(__name__)

@app.route('/')
def home():
    return "Welcome to the Automated Dashboard!"

@app.route('/modules')
def modules():
    modules_path = os.path.join(os.getcwd(), 'dashboard', 'modules')
    installed_modules = os.listdir(modules_path)
    return f"Installed Modules: {', '.join(installed_modules)}"
