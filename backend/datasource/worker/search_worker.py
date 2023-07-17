import asyncio
import logging

from broker.broker_client.base_broker_client import BaseBrokerClient

from datasource.worker.base_worker import BaseWorker
from datasource.networking_client.search_networking_client import SearchNetworkingClient
from datasource.cache.cacher.search_cacher import SearchCacher
from datasource.worker.base_worker_util import basic_consume_callback
from datasource.worker.search_worker_util import map_landmark_get_request_message_body_to_identification_list, \
    map_fuzzy_search_response_units_to_response_message_body
from datasource.exception import MappingError, DataError, CacheError, NetworkError, WorkerResponseError

logger = logging.getLogger(__name__)


class SearchWorker(BaseWorker):
    def __init__(self,
                 api_key,
                 base_url,
                 cacher_host,
                 cacher_port,
                 broker_host,
                 broker_user,
                 broker_password):
        broker_client = BaseBrokerClient(
            broker_host=broker_host,
            broker_user=broker_user,
            broker_password=broker_password
        )
        networking_client = SearchNetworkingClient(api_key=api_key, base_url=base_url)
        cacher = SearchCacher(redis_host=cacher_host, redis_port=cacher_port)

        super().__init__(broker_client=broker_client,
                         networking_client=networking_client,
                         cacher=cacher)

    def __produce_response_message_to_landmark_get_request(self, request_message_body):
        try:
            identification_list = map_landmark_get_request_message_body_to_identification_list(
                body=request_message_body)
            fuzzy_search_response_units = self._cacher.get_fuzzy_search_response_units_by_identification(
                identifications=identification_list)
            serialized_message_body = map_fuzzy_search_response_units_to_response_message_body(
                units=fuzzy_search_response_units)
        except (MappingError, DataError, CacheError) as error:
            raise WorkerResponseError from error

        return serialized_message_body

    def __produce_response_message_to_landmark_search_by_radius_request(self, request_message_body):
        try:
            fuzzy_search_response_units = self._networking_client.make_fuzzy_search_request(
                query='',
                latitude=request_message_body['latitude'],
                longitude=request_message_body['longitude']
            )
            serialized_message_body = map_fuzzy_search_response_units_to_response_message_body(
                units=fuzzy_search_response_units
            )
        except (MappingError, NetworkError, DataError, KeyError) as error:
            raise WorkerResponseError from error
        return serialized_message_body

    async def subscribe_to_landmark_get_request(self,
                                                request_exchange_name,
                                                response_exchange_name,
                                                request_topic_name,
                                                response_topic_name):
        consumption_queue = asyncio.Queue()

        await asyncio.gather(
            self._subscribe_to_topic(
                request_exchange_name=request_exchange_name,
                request_topic_name=request_topic_name,
                consumption_queue=consumption_queue,
                callback=basic_consume_callback
            ),
            self._process_request(
                response_exchange_name=response_exchange_name,
                response_topic_name=response_topic_name,
                consumption_queue=consumption_queue,
                response_produce_method=self.__produce_response_message_to_landmark_get_request
            )
        )

    async def subscribe_to_landmark_search_by_radius_request(self,
                                                             request_exchange_name,
                                                             response_exchange_name,
                                                             request_topic_name,
                                                             response_topic_name,
                                                             ):
        consumption_queue = asyncio.Queue()

        await asyncio.gather(
            self._subscribe_to_topic(
                request_exchange_name=request_exchange_name,
                request_topic_name=request_topic_name,
                consumption_queue=consumption_queue,
                callback=basic_consume_callback
            ),
            self._process_request(
                response_exchange_name=response_exchange_name,
                response_topic_name=response_topic_name,
                consumption_queue=consumption_queue,
                response_produce_method=self.__produce_response_message_to_landmark_search_by_radius_request
            )
        )
