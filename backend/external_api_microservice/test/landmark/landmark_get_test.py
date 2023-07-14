from external_api_microservice.main import app
from fastapi.testclient import TestClient

client = TestClient(app)


def test_get_landmark_by_id_endpoint():
    response = client.post(
        '/landmark/getby-id',
        json={
            'landmark': [
                {
                    'id': ''
                }
            ]
        }
    )

    print(response)

    assert response.status_code == 200
