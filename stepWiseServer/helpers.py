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
        SELECT tool_id AS id, tool_title AS title, tool_amount AS amount, link
        FROM Tools
        WHERE tutorial_id = %s
    """, (tutorial_id,))
    tool_records = cur.fetchall()
    return [
        {
            "id": str(tool_record["id"]),
            "title": tool_record["title"],
            "amount": tool_record["amount"],
            "link": tool_record["link"]
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
                    content = {"id": content_data['id'], "contentText": content_data['content_text']}
            elif sub_step['content_type'] == 2:
                cur.execute("SELECT id, content_picture_link AS pictureLink FROM PictureContent WHERE id = %s", (sub_step['content_id'],))
                content_data = cur.fetchone()
                if content_data:
                    content = {"id": content_data['id'], "pictureLink": content_data['pictureLink']}
            elif sub_step['content_type'] == 3:  # Handling VideoContent
                cur.execute("SELECT id, content_video_link AS videoLink FROM VideoContent WHERE id = %s", (sub_step['content_id'],))
                content_data = cur.fetchone()
                if content_data:
                    content = {"id": content_data['id'], "videoLink": content_data['videoLink']}

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