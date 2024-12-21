# Improved Trading Module
def init_app(app):
    @app.route("/trading_status")
    def trading_status():
        return "Trading Module Active"
