import requests
from landmark_api_microservice.client.base_networking_client import BaseNetworkingClient
from landmark_api_microservice.response_mapper.search_response_mapper import SearchResponseMapper


class SearchNetworkingClient(BaseNetworkingClient):
    def __init__(self, base_url, api_key, limit=50):
        super().__init__(base_url, api_key)
        self._limit = limit
        self._mapper = SearchResponseMapper()

    def _compose_fuzzy_search_url_with_empty_query(self, latitude, longitude, radius):
        return  f'{self._base_url}/search/2/search/{latitude},{longitude}.json' \
                f'?key={self._api_key}' \
                f'&lat={latitude}&lon={longitude}&radius={radius}&idxSet=POI'

    def _compose_fuzzy_search_url_with_query_text(self, query, latitude, longitude, radius):
        return  f'{self._base_url}/search/2/search/{query}.json' \
                f'?key={self._api_key}' \
                f'&lat={latitude}&lon={longitude}&radius={radius}&idxSet=POI'

    def make_fuzzy_search_request(self, query, latitude, longitude, radius):
        query_url = self._compose_fuzzy_search_url_with_query_text(query, latitude, longitude, radius) \
            if query is not None else self._compose_fuzzy_search_url_with_empty_query(latitude, longitude, radius)

        response = requests.get(query_url)
        return self._mapper.map_fuzzy_search_result(response)

    @property
    def limit(self):
        return self._limit

    @limit.setter
    def limit(self, value):
        self._limit = value
