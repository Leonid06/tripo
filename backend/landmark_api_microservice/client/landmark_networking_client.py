import requests
from typing import Dict
from landmark_api_microservice.client.base import BaseNetworkingClient


class SearchNetworkingClient(BaseNetworkingClient):
    def __init__(self, base_url, api_key, limit = 50):
        super().__init__(base_url, api_key)
        self._limit = limit



    def makeFuzzySearchRequest(self, radius, ):

    @property
    def limit(self):
        return self._limit

    @limit.setter
    def limit(self, value):
        self._limit = value
