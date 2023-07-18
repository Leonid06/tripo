from fastapi.testclient import TestClient

from rest.main import app

client = TestClient(app)

search_landmark_by_radius_route = 'landmark/search/by-radius'


def test_search_landmark_by_radius_endpoint_1():
    data = {
        'latitude': '51.509865',
        'longitude': '-0.118092',
        'radius' : '20000'
    }

    response = client.post(
        search_landmark_by_radius_route,
        json=data
    )

    assert response.status_code == 200


def test_search_landmark_by_radius_endpoint_2():
    data = {
        'latitude': '41.902782',
        'longitude': '12.496366',
        'radius': '50000'
    }

    response = client.post(
        search_landmark_by_radius_route,
        json=data
    )

    assert response.status_code == 200

def test_search_landmark_by_radius_endpoint_3():
    data = {
        'latitude': '48.858093',
        'longitude': '2.294694',
        'radius': '100000'
    }

    response = client.post(
        search_landmark_by_radius_route,
        json=data
    )

    assert response.status_code == 200
