from typing import overload
import requests
import os
import logging
from flask import Flask
from flask import render_template

logger = logging.getLogger('waitress')
logger.setLevel(logging.INFO)

app = Flask(__name__)

LogsLoc = [
  {
    'name': 'Plex Move',
    'location': 'up.log'
  },
  {
    'name': 'Second Log',
    'location': 'test.log'
  }
]

SendLogs = []

@app.route('/')
def show_page():
  for i, log in enumerate(LogsLoc):
    with open(log['location'],"r") as file:
      content = file.readlines()

    SendLogs.append({
      'name': log['name'],
      'location': log['location'],
      'content': content
    })
  # overall_status = os.popen('tail -n 35 up.log | sed -e "/PG Blitz Log - Cycle/q"').read().split('\n')
  # print(overall_status)
  # logs = os.popen('tail -n 35 test.log').read()


  return render_template('index.html', Logs=SendLogs) #, logs=logs

if __name__ == "__main__":
  from waitress import serve
  logging.info('Starting server on 0.0.0.0:8080...')
  serve(app, host="0.0.0.0", port=8080, threads=6)
