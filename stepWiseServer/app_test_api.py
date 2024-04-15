import datetime
import json
from flask_testing import TestCase
from app import create_app  
import boto3
import psycopg2
from psycopg2.extras import RealDictCursor
import unittest
from jsonschema import validate
from jsonschema.exceptions import ValidationError
import os
from flask import current_app
from werkzeug.security import check_password_hash, generate_password_hash
import uuid
import io
#DB Connection

def get_db_connection():
    # Use the current app's config
    conn = psycopg2.connect(
        dbname=current_app.config['DATABASE_NAME'],
        user=current_app.config['DATABASE_USER'],
        password=current_app.config['DATABASE_PASSWORD'],
        host=current_app.config['DATABASE_HOST'],
        port=current_app.config['DATABASE_PORT'],
        cursor_factory=RealDictCursor)
    return conn


class TestAPI(TestCase):
    #init app
    def create_app(self):
        test_config = {
            'TESTING': True,
            'SECRET_KEY': 'dev',
            'DATABASE_NAME': "StepWiseServer_test2",
            'DATABASE_USER': "postgres",
            'DATABASE_PASSWORD': "2NPLCP@89!to",
            'DATABASE_HOST': "127.0.0.1",
            'DATABASE_PORT': "5433",
            'TEST_ENVIRONMENT': 'True'
        }
        app = create_app(test_config)
        return app

    def setUp(self):
        self.conn = get_db_connection()
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Teardown test database, drop tables
        self.cur.close()
        self.conn.close()

    def _get_random_user(self):
        conn = get_db_connection()
        cur = conn.cursor()
        try:
            cur.execute("Select * from \"User\" u ORDER BY RANDOM() LIMIT 1")
            user = cur.fetchone()
            session_key = uuid.uuid4()
            if user['session_key'] is None:
                cur.execute("UPDATE \"User\" SET session_key = %s WHERE user_id = %s", (str(session_key), user['user_id']))
                conn.commit()
                user['session_key'] = session_key
            return user
        except Exception as e:
            self.fail("Error getting random user: " + str(e))

    # Browser Testing
    def test_get_browser_json(self):
        response = self.client.get('/api/GetBrowser')

        self.assertEqual(response.status_code, 200, "Expected HTTP 200 response.")

        schema_path = os.path.join(os.path.dirname(__file__), 'json_schemas/Tutorial.json')
        with open(schema_path) as schema_file:
            schema = json.load(schema_file)

        data = response.json

        try:
            validate(instance=data, schema=schema)
        except ValidationError as e:
            self.fail(f"Response JSON does not match the expected schema: {str(e)} status_code: {response.status_code}")

    #region Tutorial Testing
    def test_get_tutorial_json(self):
        self.cur.execute("""
                        Select *
                        from Tutorials t  
                        ORDER BY RANDOM() LIMIT 1
                        """)
        tutorial = self.cur.fetchone()
        headers = {
            "tutorial_id": tutorial['tutorial_id']
        }
        response = self.client.get('/api/tutorial/id/', headers=headers)

        self.assertEqual(response.status_code, 200, "Result: " + response.data.decode('utf-8'))

        if response.status_code == 200:
            schema_path = os.path.join(os.path.dirname(__file__), 'json_schemas/Tutorial.json')
            with open(schema_path) as schema_file:
                schema = json.load(schema_file)
            
            try:
                data = response.json
            except ValueError:
                self.fail("Response is not in JSON format.")
        
            try:
                validate(instance=data, schema=schema)
            except ValidationError as e:
                self.fail(f"Response JSON does not match the expected schema: {str(e)} status_code: {response.status_code}")

    #endregion

    #region Account Testing
    def test_change_password(self):
        
        user = {
            'user_id': "123e4567-e89b-12d3-a456-426614174000",
            'firstname': "John",
            'lastname': "Doe",
            'email': "john@example.com",
            'creator': True,
            'password_hash': "password12345",
            'session_key': None 
        }

        #override password hash to users password hash
        self.cur.execute("UPDATE \"User\" SET password_hash = %s WHERE user_id = %s", (generate_password_hash(user['password_hash']), user['user_id']))
        self.conn.commit()

        payload = {
            "user_id": user['user_id'],
            "email": user['email'],
            "currentPW": user['password_hash'],
            "newPW": "iopasdfpiasbfpas"
        }
        self.cur.execute("Select u.session_key from \"User\" u where u.user_id = %s", (user['user_id'],))
        session_key = self.cur.fetchone()

        header = {
            "session_key": session_key['session_key'],
            "user_id": user['user_id'],
        }
        response = self.client.post('/api/change_password', data=json.dumps(payload), content_type='application/json', headers=header)
        self.assertEqual(response.status_code, 200, "Result: " + response.data.decode('utf-8'))

    def test_get_session_key(self):
        payload = {
            "UserId": "123e4567-e89b-12d3-a456-426614174000",
            "email": "john@example.com",
            "password": "password12345"
        }
        response = self.client.post('/api/get_session_key', headers=payload, content_type='application/json')
        self.assertEqual(response.status_code, 200, "Result: " + response.data.decode('utf-8'))
        data = json.loads(response.data.decode('utf-8'))
        self.assertIn('SessionKey', data, "Result: " + response.data.decode('utf-8'))

    def test_create_account(self):
        #user to add
        payload = {
            "email": "test@example.com",
            "password": "newpassword",
            "firstname": "New",
            "lastname": "User"
        }

        #delete user in DB if exists
        try:
            self.cur.execute("DELETE FROM \"User\" WHERE email = %s", (payload['email'],))
            self.conn.commit()
        except Exception as e:
            self.fail("Error deleting created user: " + str(e))
        
        response = self.client.post('/api/create_account', headers=payload, content_type='application/json')
        #delete created user

        self.assertEqual(response.status_code, 201, "Result: " + response.data.decode('utf-8'))
    
    def test_get_user(self):
        self.cur.execute("Select * from \"User\" u ORDER BY RANDOM() LIMIT 1")
        user = self.cur.fetchone()
        session_key = uuid.uuid4()
        if user['session_key'] is None:
            self.cur.execute("UPDATE \"User\" SET session_key = %s WHERE user_id = %s", (str(session_key), user['user_id']))
            self.conn.commit()
        else:
            session_key = user['session_key']

        headers = {
            "user_id": user['user_id'],
            "session_key": session_key
        }

        response = self.client.get('/api/GetUser', headers=headers)
        self.assertEqual(response.status_code, 200, "Result: " + response.data.decode('utf-8'))

    def test_update_user(self):
        self.cur.execute("Select * from \"User\" u ORDER BY RANDOM() LIMIT 1")
        user = self.cur.fetchone()
        session_key = uuid.uuid4()
        #update session key if none
        if user['session_key'] is None:
            self.cur.execute("UPDATE \"User\" SET session_key = %s WHERE user_id = %s", (str(session_key), user['user_id']))
            self.conn.commit()
        else:
            session_key = user['session_key']

        payload = {
            "user_id": user['user_id'],
            "session_key": str(session_key),
            "firstname": "John",
            "lastname": "Doe",
            "email": "john@example.com",
            "creator": True
        }

        header = {
            "user_id": user['user_id'],
            "session_key": str(session_key)
        }

        response = self.client.post('/api/UpdateUser', data=json.dumps(payload), headers=header, content_type='application/json')
        self.assertEqual(response.status_code, 200, "Result: " + response.data.decode('utf-8'))

    #endregion

    #region History Testing
    def test_get_history(self):
        self.cur.execute("Select * from \"User\" u ORDER BY RANDOM() LIMIT 1")
        user = self.cur.fetchone()
        session_key = uuid.uuid4()
        if user['session_key'] is None:
            self.cur.execute("UPDATE \"User\" SET session_key = %s WHERE user_id = %s", (str(session_key), user['user_id']))
            self.conn.commit()
        else:
            session_key = user['session_key']

        headers = {
            "user_id": user['user_id'],
            "session_key": session_key
        }

        #Adding single history list to user to have a history
        # self.cur.execute("Select tutorial_id from Tutorials ORDER BY RANDOM() LIMIT 1")
        # tutorial = self.cur.fetchone()

        # self.cur.execute("""
        #                 Insert into Watch_History
        #                 (user_id, tutorial_id,last_watched_time, completed_steps)
        #                 values (%s, %s,2024-03-30 14:51:39.474617+01,0)
        #                 """,
        #             (user['user_id'],tutorial['tutorial_id']))
        # self.conn.commit()

        #Checking json schema
        schema_path = os.path.join(os.path.dirname(__file__), 'json_schemas/Tutorial.json')
        with open(schema_path) as schema_file:
            schema = json.load(schema_file)

        response = self.client.get('/api/GetHistoryList', headers=headers)

        self.assertIn(response.status_code, [200,201], "Result: " + response.data.decode('utf-8'))
        if response.status_code == 200:
            try:
                data = response.json
                validate(instance=data, schema=schema)
            except ValidationError as e:
                self.fail(f"Response JSON does not match the expected schema: {str(e)} status_code: {response.status_code}")
    
    def test_delete_history_single(self):
        self.cur.execute("Select * from \"User\" u ORDER BY RANDOM() LIMIT 1")
        user = self.cur.fetchone()
        session_key = uuid.uuid4()
        if user['session_key'] is None:
            self.cur.execute("UPDATE \"User\" SET session_key = %s WHERE user_id = %s", (str(session_key), user['user_id']))
            self.conn.commit()
        else:
            session_key = user['session_key']

        #Tutorial to delete selected randomly
        self.cur.execute("Select tutorial_id from Tutorials ORDER BY RANDOM() LIMIT 1")
        tutorial = self.cur.fetchone()

        #Insert history to delete
        current_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        self.cur.execute("""
                        Insert into Watch_History 
                        (user_id, tutorial_id,last_watched_time, completed_steps) 
                        values (%s, %s,%s,0)
                        """, 
                    (user['user_id'],tutorial['tutorial_id'], current_time))
        self.conn.commit()

        headers = {
            "user_id": user['user_id'],
            "session_key": session_key,
            "tutorial_id": tutorial['tutorial_id']
        }

        response = self.client.delete('/api/DeleteHistorySingle', headers=headers)

        # Check if history was deleted
        self.cur.execute("SELECT * FROM Watch_History WHERE user_id = %s AND tutorial_id = %s", (user['user_id'], tutorial['tutorial_id']))
        history = self.cur.fetchone()
        if history is not None:
            self.fail("History not deleted.")

        self.assertEqual(response.status_code, 200, "Result: " + response.data.decode('utf-8'))

    def test_delete_history(self):
        self.cur.execute("Select * from \"User\" u ORDER BY RANDOM() LIMIT 1")
        user = self.cur.fetchone()
        session_key = uuid.uuid4()
        if user['session_key'] is None:
            self.cur.execute("UPDATE \"User\" SET session_key = %s WHERE user_id = %s", (str(session_key), user['user_id']))
            self.conn.commit()
        else:
            session_key = user['session_key']

        #Tutorial to delete selected randomly
        self.cur.execute("Select tutorial_id from Tutorials ORDER BY RANDOM() LIMIT 1")
        tutorial = self.cur.fetchone()

        #Insert history to delete
        current_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        self.cur.execute("""
                        Insert into Watch_History 
                        (user_id, tutorial_id,last_watched_time, completed_steps) 
                        values (%s, %s,%s,0)
                        """, 
                    (user['user_id'],tutorial['tutorial_id'],current_time))
        self.conn.commit()

        headers = {
            "user_id": user['user_id'],
            "session_key": session_key,
            "tutorial_id": tutorial['tutorial_id']
        }

        response = self.client.delete('/api/DeleteHistorySingle', headers=headers)

        # Check if history was deleted
        self.cur.execute("SELECT * FROM Watch_History WHERE user_id = %s ", (user['user_id'],))
        history = self.cur.fetchone()
        if history is not None:
            self.fail("History not deleted.")

        self.assertEqual(response.status_code, 200, "Result: " + response.data.decode('utf-8'))

    #endregion

    #region Search Testing

    def test_search_query(self):
        user = self._get_random_user()

        headers = {
            "user_id": user['user_id'],
            "session_key": user['session_key'],
        }

        response = self.client.get('/api/SearchQuery', headers=headers)
        self.assertEqual(response.status_code, 200, "Result: " + response.data.decode('utf-8'))


    #endregion
    # def test_video_upload(self):
    #     # Get the directory of the current script
    #     current_directory = os.path.dirname(__file__)
    #     # Construct the path to the MP4 file relative to the current script
    #     file_path = os.path.join(current_directory, 'IMG_2696.MP4')

    #     with open(file_path, 'rb') as mp4:
    #         data = {
    #             'file': (mp4, 'IMG_2696.MP4')
    #         }
    #         response = self.client.post('/api/VideoUpload', content_type='multipart/form-data', data=data)

    #     self.assertEqual(response.status_code, 200, "Result: " + response.data.decode('utf-8'))

    # # def test_picture_upload(self):
    #     # Get the directory of the current script
    #     current_directory = os.path.dirname(__file__)
    #     # Construct the path to the MP4 file relative to the current script
    #     file_path = os.path.join(current_directory, 'Amazon_Web_Services-Logo.PNG')

    #     with open(file_path, 'rb') as jpg:
    #         data = {
    #             'file': (jpg, 'Amazon_Web_Services-Logo.PNG')
    #         }
    #         response = self.client.post('/api/PictureUpload', content_type='multipart/form-data', data=data)

    #     self.assertEqual(response.status_code, 200, "Result: " + response.data.decode('utf-8'))

if __name__ == '__main__':
    unittest.main()