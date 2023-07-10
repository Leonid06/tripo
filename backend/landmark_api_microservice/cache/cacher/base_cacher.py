from redis import Redis


class BaseCacher:
    def __init__(self, redis_host, redis_port):
        self._redis = Redis(host=redis_host, port=redis_port, decode_responses=True)


