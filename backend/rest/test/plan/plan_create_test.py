from datetime import datetime

from fastapi.testclient import TestClient

from rest.main import app

client = TestClient(app)


def test_plan_create():
    visit_date = datetime.now().strftime(format='%Y-%m-%d %H:%M:%S')
    data = {
        'name': 'string',
        'description': 'string',
        'plan_to_landmark': [
            {
                'landmark_id': 1,
                'visit_date': visit_date
            }
        ]
    }
    response = client.post('/plan/create/manual', json=data)
    assert response.status_code == 200
