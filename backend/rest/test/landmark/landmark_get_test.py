from fastapi.testclient import TestClient
from redis import Redis
from uuid import uuid4

from rest.main import app
from rest.config import REDIS_HOST, REDIS_PORT

client = TestClient(app)

redis_instance = Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)


def test_get_landmark_by_id_endpoint():
    data = {
        'name': 'test_name'
    }
    test_id = str(uuid4())
    redis_instance.hset(test_id, mapping=data)

    response = client.post(
        '/landmark/get/by-id',
        json={
            'landmark': [
                {
                    'id': test_id
                }
            ]
        }
    )
    assert response.status_code == 200
