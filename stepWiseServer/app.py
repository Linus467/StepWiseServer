from flasgger import Swagger
from flask import Flask, jsonify, request, abort

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Nothing Here!</p>"

if __name__ == "__main__":
    app.run(host="127.0.0.0")
