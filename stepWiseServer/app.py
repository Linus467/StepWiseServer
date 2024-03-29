from flasgger import Swagger
from flask import Flask, jsonify, request, abort

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Nothing Here!</p>"

if __name__ == "__main__":
    app.run(host="127.0.0.0")

@app.route("/api/comment", methods=["GET"])
def get_comment():
    comment = [
        {
            "id": "1E2DFA89-496A-47FD-9941-DF1FC4E6484A",
            "stepID": "D81EC5BD-9D67-4F8C-81F2-DBD5AFDDB5F2",
            "text": "This is a comment text.",
            "user": {
                "email": "john.doe@example.com",
                "firstName": "John",
                "id": "550E8400-E29B-41D4-A716-446655440000",
                "isCreator": True,
                "lastName": "Doe",
                "passwordHash": "hashedpassword"
            }
        },
        {
            "id": "2F3E4A89-123B-45CD-6789-EF1FC4E6484A",
            "stepID": "12e1ca18-1f83-4391-bdb4-b07f55045ceb",
            "text": "Another comment text here.",
            "user": {
                "email": "jane.smith@example.com",
                "firstName": "Jane",
                "id": "6e384109-11e9-4c68-ab03-da3393f9e08c",
                "isCreator": False,
                "lastName": "Smith",
                "passwordHash": "differenthashedpassword"
            }
        }
    ]

    return jsonify(comment)

@app.route("/api/tutorial", methods=["GET"])
def get_tutorial():
    tutorial_data = [
        {
    "id": "1E2DFA89-496A-47FD-9941-DF1FC4E6484A",
    "title": "How to Start with Woodworking",
    "tutorialKind": "DIY",
    "user": {
        "id": "550E8400-E29B-41D4-A716-446655440000",
        "firstName": "John",
        "lastName": "Doe",
        "email": "john.doe@example.com",
        "isCreator": True
    },
    "time": 6000,
    "difficulty": 2,
    "completed": False,
    "description": "A beginner's guide to starting with woodworking.",
    "previewPictureLink": "https://example.com/image.jpg",
    "previewType": "Image",
    "views": 150,
    "steps": [
        {
        "id": "2F3E4A89-123B-45CD-6789-EF1FC4E6484B",
        "title": "Preparing the Wood",
        "subStepList": [
            {
            "id": "f5617f3a-472c-45cf-9adb-4ed11c9cc22f",
            "type": 1,
            "content": {
                "text": {
                "id": "ef19622b-29ca-48ac-a81c-8ac701c5c466",
                "contentText": "Measure and cut the wood planks to the required sizes."
                }
            }
            },
            {
            "id": "e5b0012d-c873-4858-b710-9b932d874356",
            "type": 2,
            "content": {
                "picture": {
                "id": "4c6a9b0f-d6b7-47ee-8a2d-261915118828",
                "pictureLink": "https://example.com/steps/cutting.jpg"
                }
            }
            }
        ]
        }
    ],
    "tools": [
        {
        "id": "263586bf-9302-4430-ad93-b138c5173e42",
        "title": "Hammer",
        "amount": 1,
        "link": "https://example.com/tools/hammer"
        }
    ],
    "materials": [
        {
        "id": "4E5F6A70-1112-43CD-2222-7B8C9D0EBC1A",
        "title": "Wood Planks",
        "amount": 5,
        "link": "https://example.com/materials/wood-planks"
        }
    ],
    "ratings": [
        {
        "id": "355c8bd0-8e82-451e-ab07-d8fffc6e1205",
        "user": {
            "id": "f96b9369-c6e7-45d3-9020-b65a65d8765a",
            "firstName": "Jane",
            "lastName": "Smith",
            "email": "jane.smith@example.com",
            "isCreator": False
        },
        "rating": 5
        }
    ],
    "userComments": [
        {
        "id": "d43e34b3-877c-4d2b-989b-98739a2323f1",
        "stepID": "2F3E4A89-123B-45CD-6789-EF1FC4E6484B",
        "text": "This was really helpful, thanks!",
        "user": {
            "id": "928cda31-39e1-4ae5-8dc2-4e0215864575",
            "firstName": "John",
            "lastName": "Doe",
            "email": "john.doe@example.com",
            "isCreator": True
        }
        }
    ]
    },
        {
    "id": "3A1BCD22-333D-44EF-ABC1-223344556677",
    "title": "Introduction to Python Programming",
    "tutorialKind": "Educational",
    "user": {
        "id": "550E8400-E29B-41D4-A716-446655440000",
        "firstName": "Alice",
        "lastName": "Johnson",
        "email": "alice.johnson@example.com",
        "isCreator": True
    },
    "time": 90000,
    "difficulty": 3,
    "completed": False,
    "description": "Learn the basics of Python programming language.",
    "previewPictureLink": "https://example.com/python-intro.jpg",
    "previewType": "Image",
    "views": 200,
    "steps": [
        {
        "id": "81f649ea-34c7-4e21-92c5-0fe27423c4e9",
        "title": "Installing Python",
        "subStepList": [
            {
            "id": "2659ad7e-07cc-4832-8679-37ec5e8a1e27",
            "type": 1,
            "content": {
                "text": {
                "id": "c7dfb348-68dd-4969-b265-3b1b0b532dcf",
                "contentText": "Download and install Python on your computer."
                }
            }
            },
            {
            "id": "881b8aa9-c0fb-468b-8cc5-e2df983bea92",
            "type": 2,
            "content": {
                "picture": {
                "id": "5588e91d-80b2-48ec-8c06-5f7cc6dc51e3",
                "pictureLink": "https://example.com/install-python.png"
                }
            }
            }
        ]
        }
    ],
    "tools": [
        {
        "id": "0b1a194e-501f-4cc2-9236-5aaed9a85872",
        "title": "Code Editor",
        "amount": 1,
        "link": "https://example.com/tools/code-editor"
        }
    ],
    "materials": [
        {
        "id": "14f0be1d-53c3-45eb-8bed-1fb88554aaab",
        "title": "Python Book",
        "amount": 1,
        "link": "https://example.com/materials/python-book"
        }
    ],
    "ratings": [
        {
        "id": "62319fc4-f637-4374-b505-46f56d80ab79",
        "user": {
            "id": "ABCDEF11-222A-33BC-ABC2-334455667788",
            "firstName": "Bob",
            "lastName": "Smith",
            "email": "bob.smith@example.com",
            "isCreator": False
        },
        "rating": 4
        }
    ],
    "userComments": [
        {
        "id": "e54960da-3b17-4bb4-910a-cc8366606799",
        "stepID": "a6f2bab0-5c97-4ce5-95b6-15112234a444",
        "text": "This tutorial was very helpful!",
        "user": {
            "id": "e630fb09-4b8a-4e53-9063-9f6b78f2bdcd",
            "firstName": "Charlie",
            "lastName": "Brown",
            "email": "charlie.brown@example.com",
            "isCreator": False
        }
        }
    ]
    }

    ]

    
    return jsonify(tutorial_data)

