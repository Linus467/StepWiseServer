import json
from flask_testing import TestCase
from app import create_app  
import boto3

class TestAPI(TestCase):
    def create_app(self):
        app = create_app()
        app.config['TESTING'] = True
        app.config['DEBUG'] = False
        app.config['DATABASE_URI'] = 'your_test_database_uri'
        return app

    def setUp(self):
        self.conn = psycopg2.connect(app.config['DATABASE_URI'])
        self.cur = self.conn.cursor()

    def tearDown(self):
        # Teardown test database, drop tables
        self.cur.close()
        self.conn.close()

    def test_change_password(self):
        payload = {
            "UserId": "valid_user_uuid",
            "email": "user@example.com",
            "currentPW": "oldpassword",
            "newPW": "newpassword"
        }
        response = self.client.post('/api/change_password', data=json.dumps(payload), content_type='application/json')
        self.assertEqual(response.status_code, 200)
    
    def test_get_session_key(self):
        payload = {
            "UserId": "valid_user_uuid",
            "email": "user@example.com",
            "password": "validpassword"
        }
        response = self.client.post('/api/get_session_key', data=json.dumps(payload), content_type='application/json')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data.decode('utf-8'))
        self.assertIn('SessionKey', data)

    def test_create_account(self):
        payload = {
            "email": "newuser@example.com",
            "password": "newpassword",
            "firstname": "New",
            "lastname": "User"
        }
        response = self.client.post('/api/create_account', data=json.dumps(payload), content_type='application/json')
        self.assertEqual(response.status_code, 201)

if __name__ == '__main__':
    import unittest
    unittest.main()
