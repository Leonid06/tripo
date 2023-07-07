

from landmark_api_microservice.config import BASE_URL, API_KEY


class BaseNetworkingClient():
    def __init__(self, base_url, api_key):
        self._base_url = base_url
        self._api_key = api_key


