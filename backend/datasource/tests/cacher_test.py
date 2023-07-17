from datasource.cache.cacher.search_cacher import SearchCacher
from datasource.models.response.search import FuzzySearchMappedResponseUnit
from datasource.config import REDIS_HOST, REDIS_PORT
from uuid import uuid4


def test_cache_fuzzy_search_response_units():
    units = [
        FuzzySearchMappedResponseUnit(name= 'TestUnit1', id = str(uuid4())),
        FuzzySearchMappedResponseUnit(name= 'TestUnit2', id = str(uuid4()))
    ]
    cacher = SearchCacher(redis_host= REDIS_HOST, redis_port= REDIS_PORT)

    cacher.cache_fuzzy_search_response_units(units)