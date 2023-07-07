import requests
from landmark_api_microservice.client.base_networking_client import BaseNetworkingClient
from landmark_api_microservice.response_mapper.search_response_mapper import SearchResponseMapper


class SearchNetworkingClient(BaseNetworkingClient):
    def __init__(self, base_url, api_key, limit=50):
        super().__init__(base_url, api_key)
        self._limit = limit
        self._mapper = SearchResponseMapper()

    def map_fuzzy_search_request(self, latitude, longitude, radius):
        query_url = f'{self._base_url}/search/2/search/.json?key={self._api_key}' \
                    f'&lat={latitude}&lon={longitude}&radius={radius}'

        response = requests.get(query_url)
        return self._mapper.map_fuzzy_search_result(response)

    @property
    def limit(self):
        return self._limit

    @limit.setter
    def limit(self, value):
        self._limit = value
