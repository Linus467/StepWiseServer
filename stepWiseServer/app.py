from flasgger import Swagger
from flask import Flask, jsonify, request, abort
import boto3
import psycopg2
from psycopg2.extras import RealDictCursor
import pdb
import helpers

#DB Connection


app = Flask(__name__)

s3 = boto3.client('s3',
                  endpoint_url='http://localhost:9000',
                  aws_access_key_id='6SIIaxeYMcBFyUwWzVVg',
                  aws_secret_access_key='VcOrF8xljFj3Pp8kQZAlgTmik3F9c16XvhvwVxPO',
                  region_name='eu-central-1')

buckets = s3.list_buckets()
for bucket in buckets['Buckets']:
    print(bucket['Name'])

@app.route("/")
def hello_world():
    return "<p>Nothing Here!</p>"

if __name__ == "__main__":
    app.run(host="127.0.0.1", debug=True)

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
            "title": "Woodworking Basics",
            "tutorialKind": "DIY",
            "user": {
                "id": "550E8400-E29B-41D4-A716-446655440000",
                "firstName": "Alex",
                "lastName": "Johnson",
                "email": "alex.johnson@example.com",
                "isCreator": True
            },
            "time": 3600,
            "difficulty": 2,
            "completed": False,
            "description": "Learn the basics of woodworking, from selecting wood to cutting and finishing.",
            "previewPictureLink": "https://example.com/images/woodworking.jpg",
            "previewType": "Image",
            "views": 120,
            "steps": [
                {
                    "id": "2F3E4A89-123B-45CD-6789-EF1FC4E6484B",
                    "title": "Selecting Your Wood",
                    "subStepList": [
                        {
                            "id": "ef19622b-29ca-48ac-a81c-8ac701c5c466",
                            "type": 1,
                            "content": {
                                "text": {
                                    "id": "f5617f3a-472c-45cf-9adb-4ed11c9cc22f",
                                    "contentText": "Learn how to select the right type of wood for your project."
                                }
                            }
                        },
                        {
                            "id": "4c6a9b0f-d6b7-47ee-8a2d-261915118828",
                            "type": 2,
                            "content": {
                                "picture": {
                                    "id": "e5b0012d-c873-4858-b710-9b932d874356",
                                    "pictureLink": "https://example.com/images/selecting-wood.jpg"
                                }
                            }
                        }
                    ],
                    "userComments": [
                        {
                            "id": "d43e34b3-877c-4d2b-989b-98739a2323f1",
                            "user": {
                                "id": "928cda31-39e1-4ae5-8dc2-4e0215864575",
                                "firstName": "John",
                                "lastName": "Doe",
                                "email": "john.doe@example.com",
                                "isCreator": True
                            },
                            "text": "Thanks, this helped a lot with my project!"
                        }
                    ]
                },
                {
                    "id": "2F3E4A89-123B-45CD-6789-EF1FC4E6484C",
                    "title": "Cutting Techniques",
                    "subStepList": [
                        {
                            "id": "3c4d9b0f-d6b7-47ee-8a2d-261915118829",
                            "type": 1,
                            "content": {
                                "text": {
                                    "id": "e6a1f3a2-472c-45cf-9adb-4ed11c9cc230",
                                    "contentText": "Learn different cutting techniques for woodworking."
                                }
                            }
                        }
                    ],
                    "userComments": [ 
                        {
                            "id": "d43e34b3-877c-4d2b-989b-98739a2323f2",
                            "user": {
                                "id": "928cda31-39e1-4ae5-8dc2-4e0215864576",
                                "firstName": "Sarah",
                                "lastName": "Johnson",
                                "email": "sarah.johnson@example.com",
                                "isCreator": True
                            },
                            "text": "This tutorial really expanded my woodworking skills!"
                        }
                    ]
                }
            ],
            "tools": [
                {
                    "id": "263586bf-9302-4430-ad93-b138c5173e42",
                    "title": "Saw",
                    "amount": 1,
                    "link": "https://example.com/tools/saw"
                }
            ],
            "materials": [
                {
                    "id": "4E5F6A70-1112-43CD-2222-7B8C9D0EBC1A",
                    "title": "Pine Wood",
                    "amount": 3,
                    "price": 10.99,
                    "link": "https://example.com/materials/pine-wood"
                }
            ],
            "ratings": [
                {
                    "id": "355c8bd0-8e82-451e-ab07-d8fffc6e1205",
                    "user": {
                        "id": "f96b9369-c6e7-45d3-9020-b65a65d8765a",
                        "firstName": "Jane",
                        "lastName": "Doe",
                        "email": "jane.doe@example.com",
                        "isCreator": False
                    },
                    "rating": 5,
                    "text": "Very informative and easy to follow."
                }
            ]
        }
    ]

    return jsonify(tutorial_data)

@app.route("/api/tutorial/id/", methods=["GET"])
def get_tutorial_data():
    conn = psycopg2.connect(
        dbname="StepWiseServer",
        user="postgres",
        password="Gierath-02",  # Use your actual password
        host="127.0.0.1",
        port="5432",
        cursor_factory=RealDictCursor
    )
    cur = conn.cursor()
    tutorial_id = request.args.get('tutorial_id')
    if not tutorial_id:
        return jsonify({"error": "Missing tutorial_id parameter"}), 400

    try:
        cur.execute("""
            SELECT
                t.tutorial_id,
                t.title,
                t.tutorial_kind,
                u.user_id,
                u.firstname,
                u.lastname,
                u.email,
                u.creator,
                t.time,
                t.difficulty,
                t.complete,
                t.description,
                t.preview_picture_link,
                t.preview_type,
                t.views,
                t.steps
            FROM Tutorials t
            INNER JOIN "User" u ON t.user_id = u.user_id
            WHERE t.tutorial_id = %s
        """, (tutorial_id,))
        tutorial_data = cur.fetchone()

        if not tutorial_data:
            return jsonify({"error": "Tutorial not found"}), 404

        #fetch Materials
        cur.execute("""
            SELECT
                material_id AS id,
                mat_title AS title,
                mat_amount AS amount,
                mat_price AS price,
                link
            FROM Material
            WHERE tutorial_id = %s
        """, (tutorial_id,))
        material_records = cur.fetchall()

        materials = []
        for material in material_records:
            materials.append({
                "id": material["id"],
                "title": material["title"],
                "amount": material["amount"],
                "link": material["link"],
                "price": material["price"]
            })

        # Fetch Tools
        cur.execute("""
            SELECT tool_id AS id, tool_title AS title, tool_amount AS amount, link
            FROM Tools
            WHERE tutorial_id = %s
        """, (tutorial_id,))
        tool_records = cur.fetchall()

        # Transform the tools to match the JSON structure
        tools = [
            {
                "id": str(tool_record["id"]),  # Convert UUID to string
                "title": tool_record["title"],
                "amount": tool_record["amount"],
                "link": tool_record["link"]
            }
            for tool_record in tool_records
        ]

        # Initialize an empty list for steps
        steps = []

        # Fetch Step IDs and titles
        cur.execute("""
            SELECT step_id, title
            FROM Steps
            WHERE tutorial_id = %s
        """, (tutorial_id,))
        step_records = cur.fetchall()

        for step_record in step_records:
            cur.execute("""
                SELECT ssl.sub_step_id, ss.content_type, ss.content_id
                FROM SubStepsList ssl
                INNER JOIN SubSteps ss ON ssl.sub_step_id = ss.sub_step_id
                WHERE ssl.step_id = %s
            """, (step_record['step_id'],))
            sub_steps = cur.fetchall()

            adjusted_sub_steps = []
            for sub_step in sub_steps:
                content = None
                if sub_step['content_type'] == 1:
                    cur.execute("SELECT id, content_text FROM TextContent WHERE id = %s", (sub_step['content_id'],))
                    content_data = cur.fetchone()
                    if content_data:
                        content = {"text": {"id": content_data['id'], "contentText": content_data['content_text']}}
                elif sub_step['content_type'] == 2:
                    cur.execute("SELECT id, content_picture_link AS pictureLink FROM PictureContent WHERE id = %s", (sub_step['content_id'],))
                    content_data = cur.fetchone()
                    if content_data:
                        content = {"picture": {"id": content_data['id'], "pictureLink": content_data['pictureLink']}}
                elif sub_step['content_type'] == 3:  # Handling VideoContent
                    cur.execute("SELECT id, content_video_link AS videoLink FROM VideoContent WHERE id = %s", (sub_step['content_id'],))
                    content_data = cur.fetchone()
                    if content_data:
                        content = {"video": {"id": content_data['id'], "videoLink": content_data['videoLink']}}

                adjusted_sub_steps.append({
                    "id": sub_step['sub_step_id'],
                    "type": sub_step['content_type'],
                    "content": content
                })

            # Fetch user comments for each step (if applicable)
            cur.execute("""
                SELECT uc.comment_id AS id, uc.text, 
                    u.user_id AS "id", u.firstname AS "firstName", 
                    u.lastname AS "lastName", u.email, u.creator AS "isCreator"
                FROM UserComments uc
                INNER JOIN "User" u ON uc.user_id = u.user_id
                WHERE uc.step_id = %s
            """, (step_record['step_id'],))
            user_comments = cur.fetchall()

            # Adjust user_comments as needed to match the expected structure
            formatted_comments = [{
                "id": comment['id'],
                "user": {
                    "id": comment['id'],  # This seems to be a mistake; ensure correct ID fields are used
                    "firstName": comment['firstName'],
                    "lastName": comment['lastName'],
                    "email": comment['email'],
                    "isCreator": comment['isCreator']
                },
                "text": comment['text']
            } for comment in user_comments]

            steps.append({
                "id": step_record['step_id'],
                "title": step_record['title'],
                "subStepList": adjusted_sub_steps,
                "userComments": formatted_comments  # Include this only if you're fetching comments
            })

        # Improved Fetch Ratings with nested User Details
        cur.execute("""
            SELECT
                r.rating_id AS id,
                r.rating,
                r.text,
                usr.user_id AS "userId",
                usr.firstname AS "firstName",
                usr.lastname AS "lastName",
                usr.email,
                usr.creator AS creator
            FROM TutorialRating r
            INNER JOIN "User" usr ON r.user_id = usr.user_id
            WHERE r.tutorial_id = %s
        """, (tutorial_id,))
        ratings_raw = cur.fetchall()

        ratings = [{
            "id": rating["id"],
            "user": {
                "id": rating["userId"],
                "firstName": rating["firstName"],
                "lastName": rating["lastName"],
                "email": rating["email"],
                "isCreator": rating["creator"]
            },
            "rating": rating["rating"],
            "text": rating["text"]
        } for rating in ratings_raw]

        tutorial_data['ratings'] = ratings

        # Construct the final tutorial_data dictionary with all related data included
        tutorial_data = {
            "id": tutorial_data["tutorial_id"],
            "title": tutorial_data["title"],
            "tutorialKind": tutorial_data["tutorial_kind"],
            "user": {
                "id": tutorial_data["user_id"],
                "firstName": tutorial_data["firstname"],
                "lastName": tutorial_data["lastname"],
                "email": tutorial_data["email"],
                "isCreator": tutorial_data["creator"]
            },
            "time": tutorial_data["time"],
            "difficulty": tutorial_data["difficulty"],
            "completed": tutorial_data["complete"],
            "description": tutorial_data["description"],
            "previewPictureLink": tutorial_data["preview_picture_link"],
            "previewType": tutorial_data["preview_type"],
            "views": tutorial_data["views"],
            "steps": steps,
            "materials": materials,
            "tools": tools,
            "ratings": ratings
        }

    finally:
        cur.close()
        conn.close()

    return jsonify([tutorial_data])
