from redis import Redis, RedisError
from landmark_api_microservice.models.response.search import FuzzySearchMappedResponseUnit
from landmark_api_microservice.exception import CacheError


def cache_fuzzy_search_response_unit(unit: FuzzySearchMappedResponseUnit, redis: Redis):
    try:
        data = {
            'name': unit.name
        }
        redis.hset(unit.id, mapping=data)
    except (RedisError, TypeError) as error:
        raise CacheError from error


def get_cached_fuzzy_search_response_unit_by_id(id: str, redis: Redis) -> FuzzySearchMappedResponseUnit | None:
    try:
        data = redis.hgetall(id)
        return FuzzySearchMappedResponseUnit(
            id=id,
            name=data['name']
        )

    except (RedisError, KeyError) as error:
        raise CacheError from error
