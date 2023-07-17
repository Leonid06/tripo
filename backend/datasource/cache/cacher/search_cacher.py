from datasource.cache.cacher.base_cacher import BaseCacher
from typing import List
from datasource.cache.search_cache_util import cache_fuzzy_search_response_unit, \
    get_cached_fuzzy_search_response_unit_by_id
from datasource.models.response.search import FuzzySearchMappedResponseUnit
from datasource.exception import DataError


class SearchCacher(BaseCacher):
    def cache_fuzzy_search_response_units(self, units: List[FuzzySearchMappedResponseUnit]):
        try:
            for unit in units:
                cache_fuzzy_search_response_unit(unit=unit, redis=self._redis)
        except TypeError as error:
            raise DataError from error

    def get_fuzzy_search_response_units_by_identification(self, identifications: List[str]) -> List[
        FuzzySearchMappedResponseUnit]:
        units = []

        try:
            for identification in identifications:
                unit = get_cached_fuzzy_search_response_unit_by_id(id=identification, redis=self._redis)
                units.append(unit)
        except TypeError as error:
            raise DataError from error

        return units
