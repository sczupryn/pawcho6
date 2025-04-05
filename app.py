from flask import Flask
import socket
import os

app = Flask(__name__)


@app.route("/")
def index():
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)
    version = os.getenv("VERSION", "1.0.0")

    return f"""
    <h1>Informacje</h1>
    <p><b>Adres IP:</b> {ip_address}</p>
    <p><b>Nazwa hosta:</b> {hostname}</p>
    <p><b>Wersja aplikacji:</b> {version}</p>
    """


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
