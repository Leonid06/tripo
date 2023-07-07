from landmark_api_microservice.client.search_networking_client import SearchNetworkingClient
from landmark_api_microservice.config import BASE_URL, API_KEY
def test_fuzzy_search_request():
    latitude = 52.377956
    longitude = 4.897070
    radius = 50000
    query = None

    client = SearchNetworkingClient(base_url= BASE_URL, api_key= API_KEY)
    assert client.make_fuzzy_search_request(
        query = query,
        latitude=latitude,
        longitude=longitude,
        radius=radius)