from landmark_api_microservice.cache.cacher.base_cacher import BaseCacher
from typing import List
from landmark_api_microservice.cache.search_cache_util import cache_fuzzy_search_response_unit, get_cached_fuzzy_search_response_unit_by_id
from landmark_api_microservice.models.response.search import FuzzySearchMappedResponseUnit


class SearchCacher(BaseCacher):
    def cache_fuzzy_search_response_units(self, units : List[FuzzySearchMappedResponseUnit]):
        for unit in units:
            cache_fuzzy_search_response_unit(unit=unit,redis=self._redis)

    def get_fuzzy_search_response_units_by_identification(self, identifications : List[str]) -> List[FuzzySearchMappedResponseUnit]:
        units = []

        for identification in identifications:
            unit = get_cached_fuzzy_search_response_unit_by_id(id=identification, redis= self._redis)
            units.append(unit)

        return units
