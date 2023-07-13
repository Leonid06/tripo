from asyncio import Queue

from landmark_api_microservice.worker.base_worker import BaseWorker
from landmark_api_microservice.client.search_networking_client import SearchNetworkingClient
from landmark_api_microservice.cache.cacher.search_cacher import SearchCacher
from landmark_api_microservice.worker.search_worker_util import landmark_get_request_topic_consume_callback,\
    map_landmark_get_request_message_body_to_identification_list,\
    map_fuzzy_search_response_units_to_serialized_landmark_get_response_message_body
from rabbitmq_microservice.consumer.async_consumer.topic_async_consumer import TopicAsyncConsumer
from rabbitmq_microservice.producer.async_producer.topic_async_producer import TopicAsyncProducer

class SearchWorker(BaseWorker):
    def __init__(self, api_key, base_url, cacher_host, cacher_port):
        client = SearchNetworkingClient(api_key=api_key, base_url=base_url)
        cacher = SearchCacher(redis_host=cacher_host, redis_port=cacher_port)
        consumer = TopicAsyncConsumer()
        producer = TopicAsyncProducer()
        super().__init__(consumer=consumer,producer=producer, client=client, cacher=cacher)

    async def __listen_to_landmark_get_request_callback_queue(self,
                                                response_topic_name,
                                                response_exchange_name,
                                                callback_queue):
        message_body = await callback_queue.get()
        identification_list = map_landmark_get_request_message_body_to_identification_list(body=message_body)
        units = self._cacher.get_fuzzy_search_units_by_identification(identifications=identification_list)
        serialized_body = map_fuzzy_search_response_units_to_serialized_landmark_get_response_message_body(units=units)

        await self._producer.open_connection()
        await self._producer.produce(
            topic=response_topic_name,
            exchange_name=response_exchange_name,
            message_body=serialized_body
        )

    async def handle_landmark_get_request(self,
                                          request_exchange_name,
                                          response_exchange_name,
                                          request_topic_name,
                                          response_topic_name):
        callback_queue = Queue()
        await self._consumer.open_connection()
        await self._consumer.consume(
            topic=request_topic_name,
            exchange_name=request_exchange_name,
            callback= landmark_get_request_topic_consume_callback,
            callback_asyncio_queue=callback_queue
        )

        while True:
            await self.__listen_to_landmark_get_request_callback_queue(
                response_topic_name=response_topic_name,
                response_exchange_name=response_exchange_name,
                callback_queue=callback_queue
            )






