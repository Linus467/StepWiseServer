from flasgger import Swagger
from flask import Flask, jsonify, request, abort

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Nothing Here!</p>"

if __name__ == "__main__":
    app.run(host="127.0.0.0")

@app.route('/toolbox', methods=['GET'])
def getToolbox():
    return jsonify({}), 200

@app.route('/materials', methods=['GET'])
def getMaterials():
    return jsonify({}), 200

@app.route('/tutorial/<uuid:tutorial_id>', methods=['GET'])
def getTutorial(tutorial_id):
    return jsonify({}), 200

@app.route('/user/<uuid:user_id>', methods=['GET'])
def getUser(user_id):
    return jsonify({}), 200

@app.route('/user/<uuid:user_id>/browser', methods=['GET'])
def getUserBrowser(user_id):
    return jsonify({}), 200

@app.route('/user/<uuid:user_id>/history', methods=['GET'])
def getUserHistory(user_id):
    return jsonify({}), 200

@app.route('/user/<uuid:user_id>/favourites', methods=['GET'])
def getUserFavouriteList(user_id):
    return jsonify({}), 200

@app.route('/user/<uuid:user_id>/search-history', methods=['GET'])
def getUserSearchHistory(user_id):
    return jsonify({}), 200

@app.route('/tutorial/<uuid:tutorial_id>/comments', methods=['GET'])
def getTutorialComment(tutorial_id):
    return jsonify({}), 200

@app.route('/history', methods=['POST'])
def addToHistory():
    return jsonify({}), 200

@app.route('/favourite', methods=['POST'])
def addFavourite():
    return jsonify({}), 200

@app.route('/user/<uuid:user_id>', methods=['DELETE'])
def deleteUser():
    return jsonify({}), 200

#delete tutorial
@app.route('/tutorial/<uuid:tutorial_id>', methods=['DELETE'])
def deleteTutorial(tutorial_id):
    if(tutorial_id == None):
        abort(400)
    return jsonify({}), 200
