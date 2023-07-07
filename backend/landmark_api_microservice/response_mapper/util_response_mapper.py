from landmark_api_microservice.response_mapper.base_response_mapper import BaseResponseMapper
from landmark_api_microservice.models.response.util import LandmarkByIdResponseUnit


class UtilResponseMapper(BaseResponseMapper):
    def map_get_landmark_by_id_response(self, response):
        deserialized_response = response.json()
        landmark_data = deserialized_response['results'][0]
        response_unit = LandmarkByIdResponseUnit(
            name = landmark_data['poi']['name']
        )
        return response_unit