import requests
from typing import Dict
from landmark_api_microservice.config import BASE_URL, API_KEY


def get_landmarks(query: str, latitude: str, longitude: str, radius: str) -> Dict:
    query_url = f'{BASE_URL}/search/2/nearbySearch/{query}.json?key={API_KEY}&lat={latitude}&lon={longitude}&radius={radius}'
    response_json = requests.get(query_url).json()
    results = response_json['results']
    landmarks_data = {
        'POIs': []
    }

    for result in results:
        result_data = {
            'name': result['poi']['name'],
            # 'address' : {
            #     'streetNumber' : result['address']['streetNumber'],
            #     'streetName' : result['address']['streetName']
            # }
        }
        print(result_data)
        landmarks_data['POIs'].append(result_data)

    return landmarks_data
