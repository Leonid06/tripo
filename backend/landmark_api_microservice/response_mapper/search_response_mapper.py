from requests import RequestException

from landmark_api_microservice.response_mapper.base_response_mapper import BaseResponseMapper
from landmark_api_microservice.models.response.search import FuzzySearchMappedResponseUnit
from landmark_api_microservice.exception import MappingError


class SearchResponseMapper(BaseResponseMapper):

    def map_fuzzy_search_result(self, response):
        try:
            deserialized_response = response.json()
            landmarks_data = deserialized_response['results']
        except (RequestException, KeyError, AttributeError) as error:
            raise MappingError from error

        mapped_response = []

        try:
            for landmark_data in landmarks_data:
                response_unit = FuzzySearchMappedResponseUnit(
                    name=landmark_data['poi']['name'],
                    id=landmark_data['id']
                )
                mapped_response.append(response_unit)
        except (TypeError, KeyError) as error:
            raise MappingError from error

        return mapped_response
