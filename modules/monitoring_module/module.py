# Improved Monitoring Module
import psutil

def init_app(app):
    @app.route("/monitoring_status")
    def monitoring_status():
        cpu_usage = psutil.cpu_percent()
        memory_usage = psutil.virtual_memory().percent
        return f"CPU: {cpu_usage}%, Memory: {memory_usage}%"
