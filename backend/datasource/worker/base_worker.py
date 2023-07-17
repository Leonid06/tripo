from broker.consumer.async_consumer.topic_async_consumer import TopicAsyncConsumer
from datasource.networking_client.search_networking_client import SearchNetworkingClient
class BaseWorker:
    def __init__(self, broker_client, networking_client, cacher):
        self._broker_client = broker_client
        self._networking_client = networking_client
        self._cacher = cacher



