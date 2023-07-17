import asyncio
import logging

from broker.broker_client.base_broker_client import BaseBrokerClient
from broker.exception import BrokerClientDataError, BrokerClientConnectionError

from datasource.worker.base_worker import BaseWorker
from datasource.networking_client.search_networking_client import SearchNetworkingClient
from datasource.cache.cacher.search_cacher import SearchCacher
from datasource.worker.search_worker_util import landmark_get_request_topic_consume_callback, \
    map_landmark_get_request_message_body_to_identification_list, \
    map_fuzzy_search_response_units_to_serialized_landmark_get_response_message_body, \
    compose_error_landmark_get_response_body
from datasource.exception import MappingError, DataError, CacheError, WorkerResponseError

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
            units = self._cacher.get_fuzzy_search_response_units_by_identification(identifications=identification_list)
            serialized_body = map_fuzzy_search_response_units_to_serialized_landmark_get_response_message_body(
                units=units)
        except (MappingError, DataError, CacheError) as error:
            raise WorkerResponseError from error

        return serialized_body

    async def __subscribe_to_landmark_get_request_topic(self,
                                                        request_topic_name,
                                                        request_exchange_name,
                                                        consumption_queue
                                                        ):
        try:
            await self._broker_client.consume_message(
                topic_name=request_topic_name,
                exchange_name=request_exchange_name,
                callback=landmark_get_request_topic_consume_callback,
                consumption_queue=consumption_queue
            )
        except (BrokerClientDataError, BrokerClientConnectionError) as error:
            logger.exception(error)

    async def __process_landmark_get_request(self,
                                             response_exchange_name,
                                             response_topic_name,
                                             consumption_queue
                                             ):

        while True:
            try:
                request_message_body = await consumption_queue.get()

                response_message_body = self.__produce_response_message_to_landmark_get_request(
                    request_message_body=request_message_body)

            except WorkerResponseError as error:
                logger.exception(error)
                response_message_body = compose_error_landmark_get_response_body()

            try:
                await self._broker_client.send_message(
                    topic_name=response_topic_name,
                    exchange_name=response_exchange_name,
                    message_body=response_message_body
                )
            except (BrokerClientDataError, BrokerClientConnectionError) as error:
                logger.exception(error)

    async def subscribe_to_landmark_get_request(self,
                                                request_exchange_name,
                                                response_exchange_name,
                                                request_topic_name,
                                                response_topic_name):
        consumption_queue = asyncio.Queue()

        await asyncio.gather(
            self.__subscribe_to_landmark_get_request_topic(
                request_exchange_name=request_exchange_name,
                request_topic_name=request_topic_name,
                consumption_queue=consumption_queue
            ),
            self.__process_landmark_get_request(
                response_exchange_name=response_exchange_name,
                response_topic_name=response_topic_name,
                consumption_queue=consumption_queue
            )
        )
