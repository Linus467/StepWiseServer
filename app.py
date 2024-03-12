from flask import Flask, jsonify, request

app = Flask(__name__)

# Example data structure for demonstration purposes
posts = [
    {"id": 1, "title": "Hello, World!", "content": "This is the first post."},
    {"id": 2, "title": "Flask is Fun", "content": "Flask is easy to get started with."}
]

@app.route('/')
def home():
    return "Welcome to the Flask API server!"

@app.route('/posts', methods=['GET'])
def get_posts():
    return jsonify(posts)

@app.route('/post/<int:post_id>', methods=['GET'])
def get_post(post_id):
    post = next((post for post in posts if post['id'] == post_id), None)
    if post is not None:
        return jsonify(post)
    else:
        return jsonify({"message": "Post not found"}), 404

@app.route('/post', methods=['POST'])
def add_post():
    if request.is_json:
        post = request.get_json()
        posts.append(post)
        return jsonify(post), 201
    else:
        return jsonify({"message": "Request must be JSON"}), 400

if __name__ == '__main__':
    app.run(debug=True)