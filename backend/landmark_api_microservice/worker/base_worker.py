from rabbitmq_microservice.consumer.async_consumer.topic_async_consumer import TopicAsyncConsumer
from landmark_api_microservice.client.search_networking_client import SearchNetworkingClient
class BaseWorker:
    def __init__(self, consumer, producer, client, cacher):
        self._consumer = consumer
        self._producer = producer
        self._client = client
        self._cacher = cacher



