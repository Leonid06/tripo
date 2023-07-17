from fastapi.testclient import TestClient
import redis
from redis import Redis
from uuid import uuid4

from rest.main import app
from rest.config import TEST_REDIS_HOST, TEST_REDIS_PORT



client = TestClient(app)

test_redis = Redis(host=TEST_REDIS_HOST, port=TEST_REDIS_PORT, decode_responses=True)


def test_get_landmark_by_id_endpoint():
    data = {
        'name' : 'test_name'
    }
    test_id = str(uuid4())
    test_redis.hset(test_id, mapping= data)

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

    print(response)

    assert response.status_code == 200
