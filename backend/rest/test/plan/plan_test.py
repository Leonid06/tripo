import json
from datetime import datetime

import pytest
from fastapi.testclient import TestClient

from db.dependencies import get_main_async_session, get_test_async_session
from db.util import generate_random_uuid_string
from rest.main import app


@pytest.fixture
def client():
    client = TestClient(app)

    app.dependency_overrides[get_main_async_session] = get_test_async_session

    return client


@pytest.fixture
def create_test_plan_data():
    visit_date = datetime.now().strftime(format='%Y-%m-%d %H:%M:%S')

    return {
        'name': generate_random_uuid_string(),
        'description': generate_random_uuid_string(),
        'plan_to_landmark': [
            {
                'landmark_id': generate_random_uuid_string(),
                'name': generate_random_uuid_string(),
                'description': generate_random_uuid_string(),
                'visit_date': visit_date
            }
        ]
    }


def test_plan_create(client, create_test_plan_data):
    data = create_test_plan_data

    create_response = client.post('/plan/create/manual', json=data)
    assert create_response.status_code == 200


def test_plan_get_by_id(client, create_test_plan_data):
    create_request_data = create_test_plan_data

    create_response = client.post('/plan/create/manual', json=create_request_data)
    assert create_response.status_code == 200

    create_response_data = json.loads(create_response.text)

    get_request_data = {
        'id': create_response_data['id']
    }

    get_response = client.post('/plan/get/by-id', json=get_request_data)

    assert get_response.status_code == 200
