from redis import Redis
from landmark_api_microservice.models.response.search import FuzzySearchMappedResponseUnit
from landmark_api_microservice.config import REDIS_HOST, REDIS_PORT

redis = Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)


def cache_fuzzy_search_response_unit(unit: FuzzySearchMappedResponseUnit):
    data = {
        'name': unit.name
    }

    redis.hset(unit.id, mapping=data)


def get_cached_fuzzy_search_response_unit_by_id(id: str) -> FuzzySearchMappedResponseUnit | None:
    try:
        data = redis.hgetall(id)
        return FuzzySearchMappedResponseUnit(
            id=id,
            name=data['name']
        )

    except:
        return None
