from redis import Redis
from landmark_api_microservice.models.response.search import FuzzySearchMappedResponseUnit



def cache_fuzzy_search_response_unit(unit: FuzzySearchMappedResponseUnit, redis : Redis):
    data = {
        'name': unit.name
    }

    redis.hset(unit.id, mapping=data)


def get_cached_fuzzy_search_response_unit_by_id(id: str, redis : Redis) -> FuzzySearchMappedResponseUnit | None:
    try:
        data = redis.hgetall(id)
        return FuzzySearchMappedResponseUnit(
            id=id,
            name=data['name']
        )

    except:
        return None
