import logging
from redis import Redis, RedisError
from landmark_api_microservice.models.response.search import FuzzySearchMappedResponseUnit
from landmark_api_microservice.exception import CacheError

logger = logging.getLogger(__name__)


def cache_fuzzy_search_response_unit(unit: FuzzySearchMappedResponseUnit, redis: Redis):
    try:
        data = {
            'name': unit.name
        }
        redis.hset(unit.id, mapping=data)
    except (RedisError, TypeError) as error:
        logger.exception(error)
        raise CacheError



def get_cached_fuzzy_search_response_unit_by_id(id: str, redis: Redis) -> FuzzySearchMappedResponseUnit | None:
    try:
        data = redis.hgetall(id)
        return FuzzySearchMappedResponseUnit(
            id=id,
            name=data['name']
        )

    except (RedisError, KeyError) as error:
        logger.exception(error)
        raise CacheError

