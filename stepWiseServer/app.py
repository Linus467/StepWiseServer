import os
from flasgger import Swagger
from flask import Flask, jsonify, request, abort, g
import boto3
from botocore.client import Config
import psycopg2
from psycopg2.extras import RealDictCursor
from functools import wraps
import pdb
#get all methods from helpers 
from helpers import (fetch_and_format_user, fetch_and_format_materials, fetch_and_format_tools,
                    fetch_and_format_steps, fetch_and_format_ratings,
                    fetch_and_format_tutorial, fetch_and_format_tutorials, fetch_and_format_whole_user)
from werkzeug.security import check_password_hash, generate_password_hash
import uuid
import json
import re
from minio import Minio
from minio.error import S3Error
import logging

def create_app(test_config=None):
    app = Flask(__name__)
    if test_config:
        app.config.from_mapping(test_config)
    else:
        app.config.from_mapping(
            SECRET_KEY='dev',
            DATABASE_NAME="stepwise",
            DATABASE_USER="postgres",
            DATABASE_PASSWORD="2NPLCP@89!to",
            DATABASE_HOST="localhost",
            DATABASE_PORT="5432",
            TEST_ENVIRONMENT='False',
            S3_DATA_BUCKET_URL = 'http://127.0.0.1:9000'
        )
    app.debug = app.config.get('TEST_ENVIRONMENT')
    s3 = boto3.client('s3',
                    config=Config(signature_version='s3v4')
    )
    # minio_client = Minio(str(app.config.get('S3_DATA_BUCKET_URL')),
    #                 access_key='e4LGvDlGjdD93i0pN1rq',
    #                 secret_key='vSlc0AS8ONBYHVKWfow0Y6NLXmEJy4xvvWhgqMK8',
    #                 secure=False,
    # )

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

    #region Decorators

    def require_auth(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            print("Request Headers:")
            for header, value in request.headers.items():
                print(f"{header}: {value}")
            user_id = request.headers.get('user-id')
            session_key = request.headers.get('session-key')
            if not user_id or not session_key or not authenticate(user_id, session_key):
                if test_config:
                    error_message = f"Authentication with Session Key failed: {user_id}, {session_key}"
                    return jsonify({"error": error_message}), 401
                return jsonify({"error": "Authentication with Session Key failed"}), 401
            return f(*args, **kwargs)
        return decorated_function

    def require_isCreator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            user_id = request.headers.get('user-id')
            # Check if the user is a creator
            conn = get_db_connection()
            cur = conn.cursor()
            cur.execute("SELECT creator FROM \"User\" WHERE user_id = %s", (user_id,))
            user = cur.fetchone()
            # If the user is not a creator, return an error response
            if not user:
                return jsonify({"error": "No User found"}), 403
            if user['creator'] == False :
                return jsonify({"error": "User is not a creator"}), 403
            cur.close()
            conn.close()
            return f(*args, **kwargs)
        return decorated_function
    
    def require_isCreator_ofTutorial(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            user_id = request.headers.get('user-id')
            tutorial_id = request.headers.get('tutorial-id')
            # Check if the user is the creator of the tutorial
            conn = get_db_connection()
            cur = conn.cursor()
            cur.execute("SELECT user_id FROM Tutorials WHERE tutorial_id = %s", (tutorial_id,))
            tutorial_creator = cur.fetchone()
            # If the user is not the creator of the tutorial, return an error response
            if not tutorial_creator:
                return jsonify({"error": "No User found"}), 403
            if str(tutorial_creator['user_id']).lower() != str(user_id).lower():
                return jsonify({"error": "User is not the creator of the tutorial"}), 403
            cur.close()
            conn.close()
            return f(*args, **kwargs)
        return decorated_function

    #endregion

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
        tutorial_id = request.headers.get('tutorial-id')
        if not tutorial_id:
            headers_json = json.dumps(dict(request.headers))
            error_message = f"Missing tutorial_id parameter. Headers: {headers_json}"
            return jsonify({"error": error_message}), 400

        try:
            tutorial_data = fetch_and_format_tutorial(cur, tutorial_id)
            if not tutorial_data:
                return jsonify({"error": "Tutorial not found"}), 404
        finally:
            cur.close()
            conn.close()

        return jsonify(tutorial_data)

    @app.route("/api/myTutorial", methods=["GET"])
    @require_auth
    def get_myTutorials():
        user_id = request.headers.get('user-id')
        conn = get_db_connection()
        cur = conn.cursor()
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
                WHERE u.user_id = %s
            """, (user_id,))
            tutorials_data = cur.fetchall()

            if not tutorials_data:
                return jsonify({"message": "No tutorials found"}), 404

            tutorials_data_result = fetch_and_format_tutorials(cur, tutorials_data)
        finally:
            cur.close()
            conn.close()

        return jsonify(tutorials_data_result), 200
    #endregion

    #region Ratings
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
            return jsonify({"error": "Database error"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200

    @app.route("/api/DeleteRating", methods=["DELETE"])
    @require_auth
    def delete_rating():
        user_id = g.user_id
        tutorial_id = request.headers.get('tutorial_id')

        if not tutorial_id:
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            # Delete the rating
            cur.execute("""
                DELETE FROM TutorialRating
                WHERE user_id = %s AND tutorial_id = %s
            """, (user_id, tutorial_id))
            conn.commit()

        except Exception as e:
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
        user_id = request.headers.get('User-Id')
        #logger print user_id
        print(f"User ID: {user_id}")
        conn = get_db_connection()
        cur = conn.cursor()
        #getting the user in the correct format
        user = fetch_and_format_whole_user(cur, user_id)
        cur.close()
        conn.close()
        if not user:
            return jsonify({"error": "User not found"}), 404
        return jsonify({"user" : user}), 200
    
    @app.route("/api/UpdateUser", methods=["POST"])
    @require_auth
    def update_user():
        data = request.json
        user_id = request.headers.get('user_id')
        firstname = data.get('firstname')
        lastname = data.get('lastname')
        email = data.get('email')
        creator = data.get('creator')

        if not all([firstname, lastname, email, creator]):
            return jsonify({"error": "Missing required fields"}), 400
        
        #DB connection
        conn = get_db_connection()
        cur = conn.cursor()

        try:
            #Getting user id and checking if user_id is the same
            cur.execute("SELECT user_id FROM \"User\" WHERE user_id = %s", (user_id,))
            user = cur.fetchone()
            if not user:
                return jsonify({"error": "User not found"}), 404
            if user['user_id'] != user_id:
                return jsonify({"error": "User not authorized"}), 403

            #Updating users credentials
            cur.execute("""
                UPDATE "User"
                SET firstname = %s, lastname = %s, email = %s, creator = %s
                WHERE user_id = %s
            """, (firstname, lastname, email, creator, user_id))
            conn.commit()
            return jsonify({"success": True}), 200
        except Exception as e:
            return jsonify({"error": "Database error"}), 500
        finally:
            cur.close()
            conn.close()
    
    #endregion

    #region History

    @app.route("/api/GetHistoryList", methods=["GET"])
    @require_auth
    def get_history_list():
        user_id = request.headers.get('user-id')
        session_key = request.headers.get('session-key')
        tutorials_data_result = []
        
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
                INNER JOIN Watch_History wh ON wh.user_id = %s
            """, (user_id,))

            tutorials_data = cur.fetchall()

            if(tutorials_data[0] == None):
                return jsonify({"Empty": "Empty"}), 201
            tutorials_data_result = []
            for tutorial_data in tutorials_data:
                # For each tutorial, fetch additional data like materials, tools, steps, and ratings
                tutorial_id = tutorial_data['tutorial_id']
                materials = fetch_and_format_materials(cur, tutorial_id)
                tools = fetch_and_format_tools(cur, tutorial_id)
                steps = fetch_and_format_steps(cur, tutorial_id)
                ratings = fetch_and_format_ratings(cur, tutorial_id)
                user = fetch_and_format_user(cur,user_id)
                # Add the fetched data to the tutorial_data dictionary
                tutorials_data_result.append({
                    "id": tutorial_data["tutorial_id"],
                    "title": tutorial_data["title"],
                    "tutorialKind": tutorial_data["tutorial_kind"],
                    "user": user,
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
                    })

            
            cur.close()
            conn.close()
        except Exception as e:
            return jsonify({"error": f"Database error: {e}"}), 500
        return jsonify(tutorials_data_result), 200

    @app.route("/api/DeleteHistorySingle", methods=["DELETE"])
    @require_auth
    def delete_history_single():
        # Get parameters from the request
        user_id = request.headers.get('user-id')
        tutorial_id = request.headers.get('tutorial_id')
        
        # DB connection
        conn = get_db_connection()
        cur = conn.cursor()
        # Delete the tutorial from the user's watch history
        try:
            cur.execute("""
                DELETE FROM Watch_History
                WHERE user_id = %s AND tutorial_id = %s
            """, (user_id, tutorial_id))
            conn.commit()
            cur.close()
            conn.close()
        except Exception as e:
            return jsonify({"error": f"Database error: {e}"}), 500
        
        return jsonify({"success": True}), 200

    @app.route("/api/DeleteHistory", methods=["DELETE"])
    @require_auth
    def delete_history():
        # Get the user_id from require auth decorator
        user_id = request.headers.get('user-id')
        
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
        query = request.headers.get('query')
        if not query:
            return get_browser()

        conn = get_db_connection()
        cur = conn.cursor()
        # Using ILIKE for case-insensitive search and % for wildcard matching
        
        search_query = f"%{query}%"
        try:
            cur.execute("""
                SELECT
                    t.tutorial_id,
                    t.title,
                    t.tutorial_kind,
                    t.description,
                    t.preview_picture_link,
                    t.preview_type,
                    t.views,
                    t.steps,
                    u.user_id,
                    u.firstname,
                    u.lastname,
                    u.email,
                    u.creator,
                    t.time,
                    t.difficulty,
                    t.complete
                FROM Tutorials t
                JOIN "User" u ON t.user_id = u.user_id
                WHERE t.title ILIKE (%s) OR t.description ILIKE (%s)
            """, (search_query, search_query))
            tutorials_output = fetch_and_format_tutorials(cur, cur.fetchall())

            if not tutorials_output:
                return jsonify({"message": "No tutorials found"}), 404

            return jsonify(tutorials_output), 200

        finally:
            cur.close()
            conn.close()
    
    #endregion

    #region Favorites

    @app.route("/api/AddFavorite", methods=["POST"])
    @require_auth
    def add_favorite():
        data = request.json
        tutorial_id = data.get("tutorial_id")
        user_id = request.headers.get("user-id")

        if not all([user_id, tutorial_id]):
            return jsonify({"error": "Missing required parameters"}), 400

        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO FavouriteList (user_id, tutorial_id)
            VALUES (%s, %s)
        """, (user_id, tutorial_id))
        conn.commit()

        cur.close()
        conn.close()

        return jsonify({"success": True}), 200

    @app.route("/api/RemoveFavorite", methods=["POST"])
    @require_auth
    def remove_favorite():
        data = request.json
        tutorial_id = data.get("tutorial_id")
        user_id = request.headers.get("user-id")
        
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
            tutorials_formatted = fetch_and_format_tutorials(cur,cur.fetchall())
            if not tutorials_formatted:
                return jsonify({"message": "No tutorials found"}), 404
        except Exception as e:
            return jsonify({"error": f"Database error: {e}"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify(tutorials_formatted), 200

    @app.route("/api/GetBrowserKind", methods=["GET"])
    def get_browser_kind():
        kind = request.headers.get('kind')
        if not kind:
            return jsonify({"error": "Kind parameter is required"}), 400
        try:
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
            
            tutorials_formatted = fetch_and_format_tutorials(cur, cur.fetchall())
            
        except Exception as e:
            return jsonify({"error": f"Database error: {e}"}), 500
        finally:
            cur.close()
            conn.close()
        if not tutorials_formatted:
            return jsonify({"message": "No tutorials found for the specified kind"}), 404
        return jsonify(tutorials_formatted), 200

    #endregion

############################################################################################################

    #region tutorialCreation

    #region content

    @app.route("/api/AddContent", methods=["POST"])
    @require_auth
    @require_isCreator_ofTutorial
    def add_content():
        data = request.json
        tutorial_id = data.get('tutorial-id')
        step_id = data.get('step-id')
        content_type = data.get('type')  # 1 for TextContent, 2 for PictureContent, 3 for VideoContent
        content = data.get('content')

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
            """, (str(content_id), content))
            conn.commit()
            sub_step_id = uuid.uuid4()
            # Insert a corresponding record into SubSteps table
            cur.execute("""
                INSERT INTO SubSteps (sub_step_id, content_type, content_id)
                VALUES (%s, %s, %s)
            """, (str(sub_step_id), content_type, str(content_id)))
            conn.commit()

            # Insert a record into SubStepsList table
            cur.execute("""
                INSERT INTO SubStepsList (sub_step_list_id, sub_step_id, step_id)
                VALUES (%s, %s, %s)
            """, (str(uuid.uuid4()), str(sub_step_id) ,str(step_id)))
            conn.commit()

        except Exception as e:
            return jsonify({"error": f"Database error: {e}"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200

    @app.route("/api/DeleteContent", methods=["DELETE"])
    @require_auth
    @require_isCreator_ofTutorial
    def delete_content():
        tutorial_id = request.headers.get('tutorial-id')
        step_id = request.headers.get('step-id')
        content_id = request.headers.get('content-id')

        if not all([tutorial_id, step_id, content_id]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            cur.execute("""Select 
                        
                        """,)
            # Fetch the content type
            cur.execute("""
                SELECT content_type, sub_step_id FROM SubSteps st
                WHERE st.content_id = %s
            """,  (content_id,))
            data = cur.fetchone()
            content_type = data['content_type']
            sub_step_id = data['sub_step_id']
            if not content_type:
                return jsonify({"error": f"Content not found for contentid:{content_id}"}), 404

            # Dynamically select table based on content_type
            if content_type == 1:
                table_name = "TextContent"
            elif content_type == 2:
                table_name = "PictureContent"
            elif content_type == 3:
                table_name = "VideoContent"
            else:
                return jsonify({"error": f"Invalid content type content_type: {content_type}"}), 400

            # Delete the content from the selected table
            cur.execute("""
                DELETE FROM %s
                WHERE id = %s
            """, (table_name,content_id,))
            conn.commit()

            cur.execute("""
                DELETE FROM SubSteps
                WHERE id = %s
            """, (sub_step_id,))
            conn.commit()

            cur.execute("""
                DELETE FROM SubStepsList
                WHERE id = %s
            """, (sub_step_id,))
            conn.commit()

        except Exception as e:
            return jsonify({"error": f"Database error {e}"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200

    #endregion

    #region step

    @app.route("/api/AddStep", methods=["POST"])
    @require_isCreator_ofTutorial
    @require_auth
    def add_step():
        data = request.json
        tutorial_id = data.get('tutorial_id')
        title = data.get('title')

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
            """, (str(step_id), str(tutorial_id), title))
            conn.commit()

        except Exception as e:
            return jsonify({"error": f"Database error {e}"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200

    @app.route("/api/DeleteStep", methods=["DELETE"])
    @require_isCreator_ofTutorial
    @require_auth
    def delete_step():
        data = request.json
        tutorial_id = data.get('tutorial_id')
        step_id = data.get('step_id')

        if not all([tutorial_id, step_id]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()


            # Delete all usercomments from step
            cur.execute("""
                DELETE FROM usercomments
                WHERE step_id = %s
                        """,(str(step_id),))
            # Delete the step from the Steps table
            cur.execute("""
                DELETE FROM Steps
                WHERE tutorial_id = %s AND step_id = %s
            """, (str(tutorial_id), str(step_id)))
            conn.commit()

        except Exception as e:
            return jsonify({"error": f"Database error {e}"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200

    #endregion

    #region tutorial

    @app.route("/api/AddTutorial", methods=["POST"])
    @require_isCreator
    @require_auth
    def add_tutorial():
        data = request.json
        user_id = request.headers.get('user_id')
        title = data.get('title')
        tutorial_kind = data.get('kind')
        time = data.get('time')
        difficulty = data.get('difficulty')
        description = data.get('description')
        preview_picture_link = data.get('previewPictureLink')
        preview_type = data.get('previewType')

        if not all([user_id, title, tutorial_kind, time, difficulty, description, preview_picture_link, preview_type]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            tutorial_id = uuid.uuid4()
            # Insert the new tutorial into the Tutorials table
            cur.execute("""
                INSERT INTO Tutorials (tutorial_id, title, tutorial_kind,
                        user_id, time, difficulty, complete, description,
                        preview_picture_link, preview_type, views, steps)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 0, 0)
            """, (str(tutorial_id), title, tutorial_kind, str(user_id),
                time, difficulty, False, description, preview_picture_link, preview_type))
            conn.commit()
            return jsonify({"success": True, "tutorial_id": str(tutorial_id)}), 200

        except Exception as e:
            return jsonify({"error": f"Database error{e}"}), 500

        finally:
            if cur: cur.close()
            if conn: conn.close()
    
    @app.route("/api/EditTutorial", methods=["PUT"])
    @require_isCreator_ofTutorial
    @require_auth 
    def edit_tutorial():
        data = request.json
        tutorial_id = request.headers.get('tutorial-id')
        
        updates = {
            'title': data.get('title'),
            'tutorial_kind': data.get('tutorial-kind'),
            'time': data.get('time'),
            'difficulty': data.get('difficulty'),
            'description': data.get('description'),
            'preview_picture_link': data.get('preview-picture-link'),
            'preview_type': data.get('preview-type')
        }
        
        set_clause = ', '.join([f"{key} = %s" 
                                for key, value in updates.items()
                                    if value is not None])
        parameters = [value for value in updates.values() if value is not None]

        if not parameters:
            return jsonify({"error": "No fields provided for update"}), 400

        parameters.append(tutorial_id.lower())

        try:
            conn = get_db_connection()
            cur = conn.cursor()
            query = f"""UPDATE public.Tutorials SET {set_clause} WHERE tutorial_id = %s;"""
            cur.execute(query, parameters)
            conn.commit
            if cur.rowcount == 0:
                return jsonify({"error": "No tutorial found with the provided ID"}), 404
            return jsonify({"success": True}), 200
        except Exception as e:
            return jsonify({"error": f"Database error: {e}"}), 500
        finally:
            cur.close()
            conn.close()

    @app.route("/api/DeleteTutorial", methods=["DELETE"])
    @require_isCreator_ofTutorial
    @require_auth
    def delete_tutorial():
        data = request.json
        tutorial_id = data.get('tutorial_id')

        if not tutorial_id:
            return jsonify({"error": "Missing required fields"}), 400
        try:
            conn = get_db_connection()
            cur = conn.cursor()

            # Delete the tutorial from the Tutorials table
            cur.execute("""
                DELETE FROM Tutorials
                WHERE tutorial_id = %s
            """, (tutorial_id,))
            conn.commit()

        except Exception as e:
            return jsonify({"error": "Database error"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200
    
    #endregion

    #region material

    @app.route("/api/AddMaterial", methods=["POST"])
    @require_isCreator_ofTutorial
    @require_auth
    def add_material():
        data = request.json
        tutorial_id = request.headers.get('tutorial-id')
        title = data.get('title')
        amount = data.get('amount')
        price = data.get('price')
        link = data.get('link')
        id = data.get('id')


        if not all([tutorial_id, title, amount, price, link]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            material_id = uuid.uuid4()
            if id != None:
                material_id = uuid.UUID(id)
            # Insert the new material into the Material table
            cur.execute("""
                INSERT INTO Material (material_id, tutorial_id, mat_title, mat_amount, mat_price, link)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (str(material_id), str(tutorial_id), title, amount, price, link))
            conn.commit()

        except Exception as e:
            return jsonify({"error": f"Database error: {e}"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200

    

    @app.route("/api/DeleteMaterial", methods=["DELETE"])
    @require_isCreator_ofTutorial
    @require_auth
    def delete_material():
        data = request.json
        tutorial_id = data.get('tutorial_id')
        material_id = data.get('material_id')

        if not all([tutorial_id, material_id]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            # Delete the material from the Material table
            cur.execute("""
                DELETE FROM Material
                WHERE tutorial_id = %s AND material_id = %s
            """, (str(tutorial_id), str(material_id)))
            conn.commit()

        except Exception as e:
            return jsonify({"error": "Database error"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200


    @app.route("/api/EditMaterial", methods=["PUT"])
    @require_isCreator_ofTutorial
    @require_auth
    def edit_material():
        data = request.json
        tutorial_id = data.get('tutorial_id')
        material_id = data.get('material_id')
        title = data.get('title')
        amount = data.get('amount')
        price = data.get('price')
        link = data.get('link')
        id = data.get('id')

        if not all([tutorial_id, material_id, title, amount, price, link, id]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            # Update the material in the Material table
            cur.execute("""
                UPDATE Material
                SET mat_title = %s, mat_amount = %s, mat_price = %s, link = %s
                WHERE tutorial_id = %s AND material_id = %s
            """, (title, amount, price, link, tutorial_id, material_id))
            conn.commit()
            return jsonify({"success": True}), 200
        except Exception as e:
            return jsonify({"error": "Database error"}), 500
        finally:
            cur.close()
            conn.close()
        



    #endregion

    #region tool

    @app.route("/api/AddTool", methods=["POST"])
    @require_isCreator_ofTutorial
    @require_auth
    def add_tool():
        data = request.json
        tutorial_id = request.headers.get('tutorial_id')
        title = data.get('title')
        amount = data.get('amount')
        link = data.get('link')
        price = data.get('price')
        id = data.get('id')

        if not all([tutorial_id, title, amount, link]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()
            tool_id = uuid.uuid4()
            if id != None:
                tool_id = uuid.UUID(id)
            # Insert the new tool into the Tools table
            cur.execute("""
                INSERT INTO Tools (tool_id, tutorial_id, tool_title, tool_amount, tool_price, link) 
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (str(tool_id), str(tutorial_id), title, amount, price, link))
            conn.commit()

        except Exception as e:
            return jsonify({"error": f"Database error: {e}"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200

    @app.route("/api/DeleteTool", methods=["DELETE"])
    @require_isCreator_ofTutorial
    @require_auth
    def delete_tool():
        data = request.json
        tutorial_id = data.get('tutorial_id')
        tool_id = data.get('tool_id')

        if not all([tutorial_id, tool_id]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            # Delete the tool from the Tools table
            cur.execute("""
                DELETE FROM Tools
                WHERE tutorial_id = %s AND tool_id = %s
            """, (str(tutorial_id), str(tool_id)))
            conn.commit()

        except Exception as e:
            return jsonify({"error": "Database error"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200
    

    @app.route("/api/EditTool", methods=["PUT"])
    @require_isCreator_ofTutorial
    @require_auth
    def edit_tool():
        data = request.json
        tutorial_id = data.get('tutorial_id')
        tool_id = data.get('tool_id')
        title = data.get('title')
        amount = data.get('amount')
        link = data.get('link')
        price = data.get('price')

        if not all([tutorial_id, tool_id, title, amount, link, price]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            # Update the tool in the Tools table
            cur.execute("""
                UPDATE Tools
                SET tool_title = %s, tool_amount = %s, tool_price = %s, link = %s
                WHERE tutorial_id = %s AND tool_id = %s
            """, (title, amount, price, link, tutorial_id, tool_id))
            conn.commit()
            return jsonify({"success": True}), 200
        except Exception as e:
            return jsonify({"error": "Database error"}), 500
        finally:
            cur.close()
            conn.close()

    #endregion

    #region searchLink

    @app.route("/api/AddSearchLink", methods=["POST"])
    @require_isCreator_ofTutorial
    @require_auth
    def add_search_link():
        data = request.json
        tutorial_id = data.get('tutorial_id')
        link = data.get('link')

        if not all([tutorial_id, link]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            # Insert the new search link into the SearchLinks table
            cur.execute("""
                INSERT INTO tutorialSearchLinks (tutorial_id, search_link_id, name_link)
                VALUES (%s, %s, %s)
            """, (str(tutorial_id),str(uuid.uuid4()), link))
            conn.commit()

        except Exception as e:
            return jsonify({"error": f"Database error: {e}"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200

    @app.route("/api/DeleteSearchLink", methods=["DELETE"])
    @require_isCreator_ofTutorial
    @require_auth
    def delete_search_link():
        data = request.json
        tutorial_id = data.get('tutorial_id')
        search_link_id = data.get('search_link_id')

        if not all([tutorial_id, search_link_id]):
            return jsonify({"error": "Missing required fields"}), 400

        try:
            conn = get_db_connection()
            cur = conn.cursor()

            # Delete the search link from the SearchLinks table
            cur.execute("""
                DELETE FROM tutorialSearchLinks
                WHERE tutorial_id = %s AND search_link_id = %s
            """, (str(tutorial_id), search_link_id))
            conn.commit()

        except Exception as e:
            print(f"An error occurred: {e}")
            return jsonify({"error": f"Database error: {e}"}), 500
        finally:
            cur.close()
            conn.close()

        return jsonify({"success": True}), 200

    #endregion

    #endregion

    #region BucketUpload

    @app.route("/api/VideoUpload", methods=["POST"])
    #@require_auth
    #@require_isCreator
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
            
        return jsonify({"Path" : f"http://localhost:4566/video/{file.name}"}), 200
    
    @app.route("/api/PictureUpload", methods=["POST"])
    def upload_picture():
        if 'file' not in request.files:
            return jsonify({"error": "No files part"}), 400
        
        file = request.files['file']
        if file.filename == '':
            return jsonify({"error": "Wrong file name"}), 400
        
        file_uuid = str(uuid.uuid4())
        file.filename = f"{file_uuid}.jpg"
        if file:
            bucket_name = 'picture'
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
        
        return jsonify({"Path": f"http://localhost:4566/picture/{file.filename}"}), 200
    #endregion
    
    return app

app = create_app()

if __name__ == "__main__":
    app.run(host="127.0.0.1", debug=True)
