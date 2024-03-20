import json
from flask_testing import TestCase
from moto import mock_dynamodb2
from app import create_app  
import boto3

class TestAPI(TestCase):
    def create_app(self):
        app = create_app()
        app.config['TESTING'] = True
        app.config['DEBUG'] = False
        return app

    def setUp(self):
        pass

    def tearDown(self):
        pass

    @mock_dynamodb2
    def test_get_toolbox(self):

        response = self.client.get('/toolbox?tutorial_id=1234')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data.decode('utf-8'))
        self.assertIsInstance(data, list)

    @mock_dynamodb2
    def test_add_to_history(self):
        payload = {
            "user_id": "user-uuid",
            "tutorial_id": "tutorial-uuid"
        }
        response = self.client.post('/add_to_history', data=json.dumps(payload), content_type='application/json')
        self.assertEqual(response.status_code, 200)

    @mock_dynamodb2
    def test_delete_user(self):
        response = self.client.delete('/delete_user?user_id=user-uuid')
        self.assertEqual(response.status_code, 200)

if __name__ == '__main__':
    import unittest
    unittest.main()
