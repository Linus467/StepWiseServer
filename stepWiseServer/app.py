import os
from flasgger import Swagger
from flask import Flask, jsonify, request, abort, g
import boto3
from botocore.client import Config
import psycopg2
from psycopg2.extras import RealDictCursor
from functools import wraps
import pdb
from helpers import (fetch_and_format_materials, fetch_and_format_tools, 
                    fetch_and_format_steps, fetch_and_format_ratings, fetch_and_format_user)
from werkzeug.security import check_password_hash, generate_password_hash
import uuid
import json
import re
from minio import Minio
from minio.error import S3Error

def create_app(test_config=None):
    app = Flask(__name__)
    if test_config:
        app.config.from_mapping(test_config)
    else:
        app.config.from_mapping(
            SECRET_KEY='dev',
            DATABASE_NAME="StepWiseServer",
            DATABASE_USER="postgres",
            DATABASE_PASSWORD="2NPLCP@89!to",
            DATABASE_HOST="127.0.0.1",
            DATABASE_PORT="5432",
            TEST_ENVIRONMENT='False',
            S3_DATA_BUCKET_URL = 'http://localhost:9000'
        )

    s3 = boto3.client('s3',
                    endpoint_url= app.config.get('S3_DATA_BUCKET_URL'),
                    aws_access_key_id='e4LGvDlGjdD93i0pN1rq',
                    aws_secret_access_key='vSlc0AS8ONBYHVKWfow0Y6NLXmEJy4xvvWhgqMK8',
                    region_name='eu-central-1',
                    config=Config(signature_version='s3v4')
    )
    minio_client = Minio(str(app.config.get('S3_DATA_BUCKET_URL')),
                    access_key='e4LGvDlGjdD93i0pN1rq',
                    secret_key='vSlc0AS8ONBYHVKWfow0Y6NLXmEJy4xvvWhgqMK8',
                    secure=False,
    )

    #DB Connection
    def get_db_connection():
        conn = psycopg2.connect(
            dbname=app.config['DATABASE_NAME'],
            user=app.config['DATABASE_USER'],
            password=app.config['DATABASE_PASSWORD'],
            host=app.config['DATABASE_HOST'],
            port=app.config['DATABASE_PORT'],
            cursor_factory=RealDictCursor)
        return conn

    def authenticate(user_id, session_key):
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT * FROM \"User\" WHERE user_id = %s AND session_key = %s", (user_id, session_key))
        user = cur.fetchone()
        cur.close()
        conn.close()
        return bool(user)

    #Decorators
    def require_auth(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            # Assuming you're sending `UserId` and `sessionKey` as headers.
            user_id = request.headers.get('user_id')
            session_key = request.headers.get('session_key')

            # Performs authentication check
            if not user_id or not session_key or not authenticate(user_id, session_key):
                # If authentication fails, return an appropriate response
                if test_config:
                    error_message = f"Authentication with Session Key failed: {user_id}, {session_key}"
                    return jsonify({"error": error_message}), 401
                return jsonify({"error": "Authentication with Session Key failed"}), 401

            # Authentication passed, call the actual view function
            return f(*args, **kwargs)
        return decorated_function

    def require_isCreator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            user_id = request.headers.get('UserId')
            # Check if the user is a creator
            conn = get_db_connection()
            cur = conn.cursor()
            cur.execute("SELECT creator FROM \"User\" WHERE user_id = %s", (user_id,))
            user = cur.fetchone()
            # If the user is not a creator, return an error response
            if not user or not user['creator']:
                return jsonify({"error": "User is not a creator"}), 403
            cur.close()
            conn.close()
            return f(*args, **kwargs)
        return decorated_function
    
    #email check
    def check_email(email):
        if re.match(r"[^@]+@[^@]+\.[^@]+", email):
            return True
        return False

    #API Endpoints

    @app.route('/')
    def index():
        return jsonify({"message" : "Hello StepWise!"})
    
    #region Tutorial
    @app.route("/api/tutorial/id/", methods=["GET"])
    def get_tutorial():
        conn = get_db_connection()
        cur = conn.cursor()
        tutorial_id = request.headers.get('tutorial_id')
        if not tutorial_id:
            headers_json = json.dumps(dict(request.headers))
            error_message = f"Missing tutorial_id parameter. Headers: {headers_json}"
            return jsonify({"error": error_message}), 400

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

            # Fetching Extra Data
            # Fetch Materials
            materials = fetch_and_format_materials(cur, tutorial_id)
            # Fetch Tools
            tools = fetch_and_format_tools(cur, tutorial_id)
            # Fetch Steps
            steps = fetch_and_format_steps(cur, tutorial_id)
            # Fetch Ratings
            ratings = fetch_and_format_ratings(cur, tutorial_id)
            
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
                "descriptionText": tutorial_data["description"],
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

    @app.route("/api/tutorial_kind", methods=["GET"])
    def get_tutorials():
        conn = get_db_connection()
        cur = conn.cursor()
        tutorial_kind = request.args.get('tutorial_kind') 
        tutorials_data = []

        try:
            if tutorial_kind:
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
                    WHERE t.tutorial_kind = %s
                """, (tutorial_kind,))
            else:
                return jsonify({"error": "Tutorial kind not received"}), 404
            
            for tutorial_data in cur.fetchall():
                # For each tutorial, fetch additional data like materials, tools, steps, and ratings
                tutorial_id = tutorial_data['tutorial_id']
                materials = fetch_and_format_materials(cur, tutorial_id)
                tools = fetch_and_format_tools(cur, tutorial_id)
                steps = fetch_and_format_steps(cur, tutorial_id)
                ratings = fetch_and_format_ratings(cur, tutorial_id)
                
                # Add the fetched data to the tutorial_data dictionary
                tutorials_data.append({
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
                })
            # Return the list of tutorials
            if(tutorial_data.count() == 0):
                return jsonify({"error": "No tutorials found"}), 404

        # close DB connection
        finally:
            cur.close()
            conn.close()

        return jsonify(tutorials_data)

    @app.route("/api/Rating", methods=["POST"])
    @require_auth
    def add_rating():
        data = request.json
        user_id = g.user_id
        tutorial_id = data.get('TutorialId')
        rating = data.get('Rating')

        if not all([user_id, tutorial_id, rating]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            # Check if the user has already rated the tutorial
            cur.execute("""
                SELECT * FROM Ratings
                WHERE user_id = %s AND tutorial_id = %s
            """, (user_id, tutorial_id))
            existing_rating = cur.fetchone()

            if existing_rating:
                # Update the existing rating
                cur.execute("""
                    UPDATE Ratings
                    SET rating = %s
                    WHERE user_id = %s AND tutorial_id = %s
                """, (rating, user_id, tutorial_id))
            else:
                # Insert a new rating
                cur.execute("""
                    INSERT INTO Ratings (user_id, tutorial_id, rating)
                    VALUES (%s, %s, %s)
                """, (user_id, tutorial_id, rating))
            conn.commit()

        except Exception as e:
            print(f"An error occurred: {e}")
            return jsonify({"error": "Database error"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200


    #endregion

    #region Account
    @app.route("/api/change_password", methods=["POST"])
    @require_auth
    def change_password():
        # Get the request data
        data = request.json
        user_id = data.get('user_id')
        currentPW = data.get('currentPW')
        newPW = data.get('newPW')
        
        if test_config:
            print("Test config is set", data, user_id, currentPW, newPW)
        # Check if all required parameters are present
        if not all([currentPW, newPW]):
            return jsonify({"error": "Missing required parameters"}), 400

        # Connect to the database
        conn = get_db_connection()
        cur = conn.cursor()

        try:
            # Fetch the user's password hash
            cur.execute("SELECT password_hash FROM \"User\" WHERE user_id = %s", (user_id,))
            user = cur.fetchone()

            # Check Users password
            if not check_password_hash(user['password_hash'], currentPW):
                if test_config:
                    error_message = f"User: {user}, Password: {currentPW}, Hash: {user['password_hash']}"
                    return jsonify({"error": error_message}), 401
                return jsonify({"error": "Invalid password"}), 401
            if not user:
                return jsonify({"error": "User not found"}), 404
            
            # Handle password change
            new_password_hash = generate_password_hash(newPW)
            cur.execute("UPDATE \"User\" SET password_hash = %s WHERE user_id = %s", (new_password_hash, user_id))
            conn.commit()
            success = True
                
        except Exception as e:
            print(f"An error occurred: {e}")
            success = False
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": success}), 200 if success else 400

    @app.route("/api/get_session_key", methods=["POST"])
    def get_session_key():
        # Get the request data
        user_id = request.headers.get('UserId')
        email = request.headers.get('email')
        password = request.headers.get('password')

        if not all([user_id, email, password]):
            return jsonify({"error": "Missing required parameters"}), 400

        # Connect to the database
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT session_key FROM \"User\" WHERE user_id = %s", (user_id,))
        current_session_key = cur.fetchone()
        if test_config:
            return jsonify({"SessionKey": current_session_key}), 200
        session_key = uuid.uuid4()

        try:
            # Fetch the user's password hash
            cur.execute("SELECT password_hash FROM \"User\" WHERE user_id = %s AND email = %s", (user_id, email))
            user = cur.fetchone()

            # Check if the user exists and the password is correct
            if not check_password_hash(user['password_hash'], password):
                if test_config:
                    returnstr = f"User: {user}, Password: {password}, Hash: {user['password_hash']}"
                    return jsonify({"error": f"Invalid credentials not found {returnstr}"}), 402

                return jsonify({"error": "Invalid credentials not found"}), 402
            if user and check_password_hash(user['password_hash'], password) and test_config:
                test = 3
            if user and check_password_hash(user['password_hash'], password):
                session_key = str(uuid.uuid4())
                cur.execute("UPDATE \"User\" SET session_key = %s WHERE user_id = %s", (session_key, user_id))
                conn.commit()
        except Exception as e:
            return jsonify({"error": "Database error"}), 500
        finally:
            cur.close()
            conn.close()

        if session_key:
            return jsonify({"SessionKey": session_key}), 200
        else:
            return jsonify({"error": "Invalid credentials or user not found"}), 401

    @app.route("/api/create_account", methods=["POST"])
    def create_account():
        # Get the request data
        email = request.headers.get('email')
        #check if email is valid
        if check_email(email) == False:
            return jsonify({"error": "Invalid email"}), 400
        
        password = request.headers.get('password')
        firstname = request.headers.get('firstname')
        lastname = request.headers.get('lastname')

        # Check if all required parameters are present
        if not all([email, password, firstname, lastname]):
            return jsonify({"error": "Missing required parameters"}), 400

        # Connect to the database
        conn = get_db_connection()
        cur = conn.cursor()
        success = False

        try:
            # Check if the email is already in use
            cur.execute("SELECT email FROM \"User\" WHERE email = %s", (email,))
            if cur.fetchone() is None:
                password_hash = generate_password_hash(password)
                cur.execute("INSERT INTO \"User\" (user_id, email, password_hash, firstname, lastname, creator) VALUES (%s, %s, %s, %s, %s, FALSE)", (str(uuid.uuid4()),email, password_hash, firstname, lastname))
                conn.commit()
                success = True
            else:
                return jsonify({"error": "Email already in use"}), 400
        except Exception as e:
            if test_config:
                return jsonify({"error": f"Database error: {e}"}), 500
            return jsonify({"error": "Database error"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": success}), 201 if success else 400

    @app.route("/api/GetUser", methods=["GET"])
    @require_auth
    def get_user():
        user_id = request.headers.get('user_id')
        conn = get_db_connection()
        cur = conn.cursor()
        #getting the user in the correct format
        user = fetch_and_format_user(cur, user_id)
        cur.close()
        conn.close()
        return jsonify(user), 200
    #endregion

    #region History
    @app.route("/api/GetHistoryList", methods=["GET"])
    @require_auth
    def get_history_list():
        user_id = request.args.get('UserId')
        session_key = request.args.get('sessionKey')
        
        if authenticate(user_id, session_key):
            conn = get_db_connection()
            cur = conn.cursor()
            cur.execute("""
                SELECT t.* FROM Tutorials t
                JOIN Watch_History h ON t.tutorial_id = h.tutorial_id
                WHERE h.user_id = %s
            """, (user_id,))
            tutorials = cur.fetchall()
            cur.close()
            conn.close()
            return jsonify(tutorials), 200
        else:
            return jsonify({"error": "Authentication failed"}), 401

    @app.route("/api/DeleteHistorySingle", methods=["DELETE"])
    @require_auth
    def delete_history_single():
        # Get parameters from the request
        user_id = g.user_id
        tutorial_id = request.args.get('TutorialId')
        
        # DB connection
        conn = get_db_connection()
        cur = conn.cursor()
        # Delete the tutorial from the user's watch history
        cur.execute("""
            DELETE FROM Watch_History
            WHERE user_id = %s AND tutorial_id = %s
        """, (user_id, tutorial_id))
        conn.commit()
        cur.close()
        conn.close()
        
        return jsonify({"success": True}), 200

    @app.route("/api/DeleteHistory", methods=["DELETE"])
    @require_auth
    def delete_history():
        # Get the user_id from require auth decorator
        user_id = g.user_id
        
        # DB connection
        conn = get_db_connection()
        cur = conn.cursor()
        # Delete all tutorials from the user's watch history
        cur.execute("""
            DELETE FROM Watch_History
            WHERE user_id = %s
        """, (user_id,))
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"success": True}), 200
    #endregion

    #region Search
    @app.route("/api/QueryString", methods=["GET"])
    def query_string():
        query = request.args.get('Query')
        if not query:
            return jsonify({"error": "Query parameter is required"}), 400

        conn = get_db_connection()
        cur = conn.cursor()
        # Useing ILIKE for case-insensitive search and % for wildcard matching
        search_query = f"%{query}%"
        cur.execute("""
            SELECT * FROM Tutorials
            WHERE title ILIKE %s OR description ILIKE %s
        """, (search_query, search_query))
        tutorials = cur.fetchall()
        cur.close()
        conn.close()

        if tutorials:
            return jsonify(tutorials), 200
        else:
            return jsonify({"message": "No tutorials found matching the query"}), 404
    #endregion

    #region Favorites
    @app.route("/api/GetFavorite", methods=["GET"])
    @require_auth
    def get_favorite():
        user_id = g.user_id

        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT t.* FROM Tutorials t
            JOIN FavouriteList f ON t.tutorial_id = f.tutorial_id
            WHERE f.user_id = %s
        """, (user_id,))
        favorite_tutorials = cur.fetchall()
        cur.close()
        conn.close()
        return jsonify(favorite_tutorials), 200

    @app.route("/api/RemoveFavorite", methods=["POST"])
    @require_auth
    def remove_favorite():
        data = request.json
        user_id = g.user_id
        tutorial_id = data.get('TutorialId')
        
        if not all([user_id, tutorial_id]):
            return jsonify({"error": "Missing required parameters"}), 400

        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            DELETE FROM FavouriteList
            WHERE user_id = %s AND tutorial_id = %s
        """, (user_id, tutorial_id))
        conn.commit()

        if cur.rowcount:
            success = True
        else:
            success = False

        cur.close()
        conn.close()

        return jsonify({"success": success}), 200 if success else 404
    #endregion

    #region Browser
    @app.route("/api/GetBrowser", methods=["GET"])
    def get_browser():
        try:
            conn = get_db_connection()
            cur = conn.cursor()
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
                    ORDER BY RANDOM() LIMIT 10
                """,)
            
            tutorials_raw = cur.fetchall()
            tutorials_formatted = []

            for tutorial in tutorials_raw:
                tutorial_id = tutorial["tutorial_id"]
                
                # Fetch Materials
                materials = fetch_and_format_materials(cur, tutorial_id)
                # Fetch Tools
                tools = fetch_and_format_tools(cur, tutorial_id)
                # Fetch Steps
                steps = fetch_and_format_steps(cur, tutorial_id)
                # Fetch Ratings
                ratings = fetch_and_format_ratings(cur, tutorial_id)
                # Fetch User
                user = fetch_and_format_user(cur, tutorial["user_id"])

                tutorial_data = {
                    "id": tutorial["tutorial_id"],
                    "title": tutorial["title"],
                    "tutorialKind": tutorial["tutorial_kind"],
                    "user": user,
                    "time": tutorial["time"],
                    "difficulty": tutorial["difficulty"],
                    "completed": tutorial["complete"],
                    "descriptionText": tutorial["description"],
                    "previewPictureLink": tutorial["preview_picture_link"],
                    "previewType": tutorial["preview_type"],
                    "views": tutorial["views"],
                    "steps": steps,
                    "materials": materials,
                    "tools": tools,
                    "ratings": ratings
                }

                tutorials_formatted.append(tutorial_data)
        except Exception as e:
            print(f"An error occurred: {e}")
            return jsonify({"error": "Database error: {e}"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify(tutorials_formatted), 200


    @app.route("/api/GetBrowserKind", methods=["GET"])
    def get_tutorial_kind():
        kind = request.headers.get('kind')
        if not kind:
            return jsonify({"error": "Kind parameter is required"}), 400

        conn = get_db_connection()
        cur = conn.cursor()
        # Adjusted to fetch 10 random tutorials of the specified kind
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
                WHERE tutorial_kind = %s 
                ORDER BY RANDOM() LIMIT 10
            """,(kind,))
        
        tutorials_raw = cur.fetchall()
        tutorials_formatted = []

        for tutorial in tutorials_raw:
            tutorial_id = tutorial["tutorial_id"]
            
            # Fetching Extra Data for each tutorial
            materials = fetch_and_format_materials(cur, tutorial_id)
            tools = fetch_and_format_tools(cur, tutorial_id)
            steps = fetch_and_format_steps(cur, tutorial_id)
            ratings = fetch_and_format_ratings(cur, tutorial_id)
            user = fetch_and_format_user(cur, tutorial["user_id"])

            tutorial_data = {
                "id": tutorial["tutorial_id"],
                "title": tutorial["title"],
                "tutorialKind": tutorial["tutorial_kind"],
                "user": user,
                "time": tutorial["time"],
                "difficulty": tutorial["difficulty"],
                "completed": tutorial["complete"],
                "description": tutorial["description"],
                "previewPictureLink": tutorial["preview_picture_link"],
                "previewType": tutorial["preview_type"],
                "views": tutorial["views"],
                "steps": steps,
                "materials": materials,
                "tools": tools,
                "ratings": ratings
            }

            tutorials_formatted.append(tutorial_data)

        cur.close()
        conn.close()

        return jsonify(tutorials_formatted), 200 if tutorials_formatted else jsonify({"message": "No tutorials found for the specified kind"}), 404

    #endregion

    #region tutorialCreation
    @app.route("/api/AddContent", methods=["POST"])
    @require_isCreator
    @require_auth
    def add_content():
        data = request.json
        tutorial_id = data.get('TutorialId')
        step_id = data.get('StepId')
        content_type = data.get('Type')  # 1 for TextContent, 2 for PictureContent, 3 for VideoContent
        content = data.get('Content')

        if not all([tutorial_id, step_id, content_type, content]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            # Dynamically select table based on content_type
            if content_type == 1:
                table_name = "TextContent"
                column_name = "content_text"
            elif content_type == 2:
                table_name = "PictureContent"
                column_name = "content_picture_link"
            elif content_type == 3:
                table_name = "VideoContent"
                column_name = "content_video_link"
            else:
                return jsonify({"error": "Invalid content type"}), 400
            
            content_id = uuid.uuid4()
            # Insert content into the selected table
            cur.execute(f"""
                INSERT INTO {table_name} (id, {column_name})
                VALUES (%s, %s)
            """, (uuid.uuid4(), content))
            sub_step_id = uuid.uuid4()
            # Insert a corresponding record into SubSteps table
            cur.execute("""
                INSERT INTO SubSteps (sub_step_id, content_type, content_id)
                VALUES (%s, %s, %s)
            """, (sub_step_id, content_type, content_id))

            # Insert a record into SubStepsList table
            cur.execute("""
                INSERT INTO SubStepsList (sub_step_list_id, sub_step_id, step_id)
                VALUES (%s, %s, %s)
            """, (uuid.uuid4(), sub_step_id ,step_id))
            conn.commit()

        except Exception as e:
            print(f"An error occurred: {e}")
            return jsonify({"error": "Database error"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200

    @app.route("/api/AddStep", methods=["POST"])
    @require_isCreator
    @require_auth
    def add_step():
        data = request.json
        tutorial_id = data.get('TutorialId')
        title = data.get('Title')

        if not all([tutorial_id, title]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            step_id = uuid.uuid4()
            # Insert the new step into the Steps table
            cur.execute("""
                INSERT INTO Steps (step_id, tutorial_id, title)
                VALUES (%s, %s, %s)
            """, (step_id, tutorial_id, title))
            conn.commit()

        except Exception as e:
            print(f"An error occurred: {e}")
            return jsonify({"error": "Database error"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200

    @app.route("/api/AddTutorial", methods=["POST"])
    @require_isCreator
    @require_auth
    def add_tutorial():
        data = request.json
        user_id = g.user_id
        title = data.get('Title')
        tutorial_kind = data.get('Kind')
        time = data.get('Time')
        difficulty = data.get('Difficulty')
        description = data.get('Description')
        preview_picture_link = data.get('PreviewPictureLink')
        preview_type = data.get('PreviewType')

        if not all([user_id, title, tutorial_kind, time, difficulty, description, preview_picture_link, preview_type]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            tutorial_id = uuid.uuid4()
            # Insert the new tutorial into the Tutorials table
            cur.execute("""
                INSERT INTO Tutorials (tutorial_id, title, tutorial_kind, user_id, time, difficulty, complete, description, preview_picture_link, preview_type, views, steps)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 0, 0)
            """, (tutorial_id, title, tutorial_kind, user_id, time, difficulty, False, description, preview_picture_link, preview_type))
            conn.commit()
            return jsonify({"success": True, "tutorial_id": str(tutorial_id)}), 200

        except Exception as e:
            print(f"An error occurred: {e}")
            return jsonify({"error": "Database error"}), 500

        finally:
            if cur: cur.close()
            if conn: conn.close()

    @app.route("/api/AddMaterial", methods=["POST"])
    @require_isCreator
    @require_auth
    def add_material():
        data = request.json
        tutorial_id = data.get('TutorialId')
        title = data.get('Title')
        amount = data.get('Amount')
        price = data.get('Price')
        link = data.get('Link')

        if not all([tutorial_id, title, amount, price, link]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            material_id = uuid.uuid4()
            # Insert the new material into the Material table
            cur.execute("""
                INSERT INTO Material (material_id, tutorial_id, mat_title, mat_amount, mat_price, link)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (material_id, tutorial_id, title, amount, price, link))
            conn.commit()

        except Exception as e:
            print(f"An error occurred: {e}")
            return jsonify({"error": "Database error"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200

    @app.route("/api/AddTool", methods=["POST"])
    @require_isCreator
    @require_auth
    def add_tool():
        data = request.json
        tutorial_id = data.get('TutorialId')
        title = data.get('Title')
        amount = data.get('Amount')
        link = data.get('Link')

        if not all([tutorial_id, title, amount, link]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            tool_id = uuid.uuid4()
            # Insert the new tool into the Tools table
            cur.execute("""
                INSERT INTO Tools (tool_id, tutorial_id, tool_title, tool_amount, link)
                VALUES (%s, %s, %s, %s, %s)
            """, (tool_id, tutorial_id, title, amount, link))
            conn.commit()

        except Exception as e:
            print(f"An error occurred: {e}")
            return jsonify({"error": "Database error"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200

    @app.route("/api/AddSearchLink", methods=["POST"])
    @require_isCreator
    @require_auth
    def add_search_link():
        data = request.json
        tutorial_id = data.get('TutorialId')
        link = data.get('Link')

        if not all([tutorial_id, link]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            # Insert the new search link into the SearchLinks table
            cur.execute("""
                INSERT INTO SearchLinks (tutorial_id, link)
                VALUES (%s, %s)
            """, (tutorial_id, link))
            conn.commit()

        except Exception as e:
            print(f"An error occurred: {e}")
            return jsonify({"error": "Database error"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200

    #endregion

    #region BucketUpload
    @app.route("/api/VideoUpload", methods=["POST"])
    # @require_auth
    # @require_isCreator
    def upload_video():
        if 'file' not in request.files:
            return jsonify({"error": "No files part"}), 400
        
        file = request.files['file']
        if file.filename == '':
            return jsonify({"error": "Wrong file name"}), 400
        
        file_uuid = str(uuid.uuid4())
        file.filename = f"{file_uuid}.mp4"
        if file:
            bucket_name = 'video'
            file_size = file.seek(0, os.SEEK_END)
            file.seek(0)
            try:
                s3.upload_fileobj(
                    file,
                    bucket_name,
                    file.filename,
                    ExtraArgs={
                        'ContentType': file.content_type
                    }
                )

            except S3Error as e:
                return jsonify({"error": str(e)}), 500
            
        return jsonify({"message:" : "Upload successful", "VideoPath" : f"{app.config.get('S3_DATA_BUCKET_URL')}/video/{file.name}"}), 200

    @app.route("/api/PictureUpload", methods=["POST"])
    # @require_auth
    # @require_isCreator
    def upload_picture():
        data = request.json
        picture_type = data.get('Type')
        if 'file' not in request.files:
            return jsonify({"error": "No files part"}), 400
        
        file = request.files['file']
        if file.filename == '':
            return jsonify({"error": "Wrong file name"}), 400
        
        file_uuid = str(uuid.uuid4())
        file_key = f"{file_uuid}.jpg"
        if file:
            bucket_name = 'picture'
            file_name = file.filename
            try:
                minio_client.put_object(
                    file,
                    bucket_name,
                    file_key,
                    content_type=file.content_type
                )

            except Exception as e:
                return jsonify({"error: " : str(e)}), 500
            
        return jsonify({"message:" : "Upload successful"}), 200

    #endregion

    return app

if __name__ == "__main__":
    app = create_app()
    app.run(host="127.0.0.1", debug=True)
