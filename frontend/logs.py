import requests
import os
import logging
from flask import Flask
from flask import render_template

logger = logging.getLogger('waitress')
logger.setLevel(logging.INFO)

logs = ['file.log']

app = Flask(__name__)

@app.route('/')
def show_page():
    backend_url = "http://" + os.environ.get("BACKEND") + os.environ.get("BACKEND_URI")
    response = requests.get(url = backend_url)

    name = str(response.json()['message']['name'])
    email = str(response.json()['message']['email'])
    phone = str(response.json()['message']['phone'])
    address = str(response.json()['message']['address'])

    return render_template('index.html', name=name, email=email, phone=phone, address=address, host=backend_url)

if __name__ == "__main__":
    from waitress import serve
    logging.info('Starting server on 0.0.0.0:8080...')
    serve(app, host="0.0.0.0", port=8080, threads=6)
