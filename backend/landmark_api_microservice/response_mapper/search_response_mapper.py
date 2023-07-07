from landmark_api_microservice.response_mapper.base_response_mapper import BaseResponseMapper
from landmark_api_microservice.models.response.search import FuzzySearchMappedResponseUnit


class SearchResponseMapper(BaseResponseMapper):

    def map_fuzzy_search_result(self, response):
        deserialized_response = response.json()
        landmarks_data = deserialized_response['results']
        mapped_response = []

        for landmark_data in landmarks_data:
            response_unit = FuzzySearchMappedResponseUnit(
                name=landmark_data['poi']['name']
            )
            mapped_response.append(response_unit)

        return mapped_response
