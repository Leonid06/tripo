# import requests
# from landmark_api_microservice.client.base_networking_client import BaseNetworkingClient
# from landmark_api_microservice.response_mapper.util_response_mapper import  UtilResponseMapper
#
#
# class UtilNetworkingClient(BaseNetworkingClient):
#     def __init__(self, base_url, api_key, limit=50):
#         super().__init__(base_url, api_key)
#         self._limit = limit
#         self._mapper = UtilResponseMapper()
#
#     def make_get_landmark_by_id_request(self, id):
#         query_url = self._mapper.map_get_landmark_by_id_response(id)
#         response = requests.get(query_url)
#         return self._mapper.map_get_landmark_by_id_response(response)
#
#     def _compose_get_landmark_by_id_request_url(self, id):
#         return f'{self._base_url}/search/2/search/place.json' \
#                f'?key={self._api_key}' \
#                f'&entityId={id}'