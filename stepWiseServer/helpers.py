from flask import jsonify
from psycopg2.extras import RealDictCursor

def fetch_and_format_user(cur, user_id):
    cur.execute("""
        SELECT user_id AS id, firstname, lastname, 
        email, creator
        FROM "User"
        WHERE user_id = %s
    """, (user_id,))
    user_record = cur.fetchone()
    if user_record:
        return {
            "id": user_record["id"],
            "firstName": user_record["firstname"],
            "lastName": user_record["lastname"],
            "email": user_record["email"],
            "isCreator": user_record["creator"]
        }
    return None

def fetch_and_format_materials(cur, tutorial_id):
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
    return [
        {
            "id": material["id"],
            "title": material["title"],
            "amount": material["amount"],
            "link": material["link"],
            "price": material["price"]
        }
        for material in material_records
    ]

def fetch_and_format_tools(cur, tutorial_id):
    cur.execute("""
        SELECT tool_id AS id, tool_title AS title, tool_amount AS amount, link, tool_price AS price
        FROM Tools
        WHERE tutorial_id = %s
    """, (tutorial_id,))
    tool_records = cur.fetchall()
    return [
        {
            "id": str(tool_record["id"]),
            "title": tool_record["title"],
            "amount": tool_record["amount"],
            "link": tool_record["link"],
            "price": tool_record["price"]
        }
        for tool_record in tool_records
    ]

def fetch_and_format_steps(cur, tutorial_id):
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
            SELECT ssl.sub_step_id, ss.content_type, ss.content_id, ssl.sub_step_height
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
                    content = {"id": content_data['id'], "contentText": content_data['content_text']}
            elif sub_step['content_type'] == 2:
                cur.execute("SELECT id, content_picture_link FROM PictureContent WHERE id = %s", (sub_step['content_id'],))
                content_data = cur.fetchone()
                if content_data:
                    content = {"id": content_data['id'], "pictureLink": content_data['content_picture_link']}
            elif sub_step['content_type'] == 3:
                cur.execute("SELECT id, content_video_link FROM VideoContent WHERE id = %s", (sub_step['content_id'],))
                content_data = cur.fetchone()
                if content_data:
                    content = {"id": content_data['id'], "videoLink": content_data['content_video_link']}

            adjusted_sub_steps.append({
                "id": sub_step['sub_step_id'],
                "type": sub_step['content_type'],
                "height": sub_step['sub_step_height'],
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
        
    return steps

def fetch_and_format_ratings(cur, tutorial_id):
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
    return ratings

def fetch_and_format_tutorial(cur, tutorial_id):
    tutorial_data = []
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
        return None

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

    return tutorial_data


def fetch_and_format_tutorials(cur, tutorials_data):
    tutorials_formatted = []

    if not tutorials_data:
        return None

    for tutorial in tutorials_data:
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
        
    return tutorials_formatted

def fetch_and_format_whole_user(cur, user_id):
    # Fetch user data
    cur.execute("""
        SELECT
            user_id AS id,
            firstname AS firstName,
            lastname AS lastName,
            email,
            creator AS isCreator
        FROM "User"
        WHERE user_id = %s
    """, (user_id,))
    user_data = cur.fetchone()
    if not user_data:
        return None

    # Fetch Watch History
    cur.execute("""
        SELECT
            wh.history_id AS id,
            t.tutorial_id AS tutorialId,
            t.title AS tutorialTitle,
            t.tutorial_kind AS tutorialKind,
            t.time AS tutorialTime,
            t.difficulty AS tutorialDifficulty,
            t.complete AS tutorialComplete,
            t.description AS tutorialDescription,
            t.preview_picture_link AS tutorialPreviewPictureLink,
            t.preview_type AS tutorialPreviewType,
            t.views AS tutorialViews,
            wh.last_watched_time AS lastWatchedTime,
            wh.completed_steps AS completedSteps
        FROM watch_history wh
        INNER JOIN tutorials t ON wh.tutorial_id = t.tutorial_id
        WHERE wh.user_id = %s
    """, (user_id,))
    watch_history = [dict(record) for record in cur.fetchall()]

    # Fetch Favorite List
    cur.execute("""
        SELECT
            fav_id AS id,
            t.tutorial_id AS tutorialId,
            t.title AS tutorialTitle,
            t.tutorial_kind AS tutorialKind,
            t.time AS tutorialTime,
            t.difficulty AS tutorialDifficulty,
            t.complete AS tutorialComplete,
            t.description AS tutorialDescription,
            t.preview_picture_link AS tutorialPreviewPictureLink,
            t.preview_type AS tutorialPreviewType,
            t.views AS tutorialViews,
            fl.date_time AS dateTime
        FROM favouritelist fl
        INNER JOIN tutorials t ON fl.tutorial_id = t.tutorial_id
        WHERE fl.user_id = %s
    """, (user_id,))
    favorite_list = [dict(record) for record in cur.fetchall()]

    # Fetch Search History
    cur.execute("""
        SELECT
            search_id AS id,
            searched_text AS searchedText
        FROM search_history
        WHERE user_id = %s
    """, (user_id,))
    search_history = [dict(record) for record in cur.fetchall()]

    user = {
        "id": user_data["id"],
        "firstName": user_data["firstname"],
        "lastName": user_data["lastname"],
        "email": user_data["email"],
        "isCreator": user_data["iscreator"],
        "watchHistory": watch_history,
        "favoriteList": favorite_list,
        "searchHistory": search_history
    }

    return user
