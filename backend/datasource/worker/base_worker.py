import logging

from broker.exception import BrokerClientDataError, BrokerClientConnectionError

from datasource.exception import WorkerResponseError
from datasource.worker.base_worker_util import compose_basic_error_landmark_get_response_body

logger = logging.getLogger(__name__)


class BaseWorker:
    def __init__(self, broker_client, networking_client, cacher):
        self._broker_client = broker_client
        self._networking_client = networking_client
        self._cacher = cacher

    async def _subscribe_to_topic(self,
                                  request_topic_name,
                                  request_exchange_name,
                                  consumption_queue,
                                  callback
                                  ):
        try:
            await self._broker_client.consume_message(
                topic_name=request_topic_name,
                exchange_name=request_exchange_name,
                callback=callback,
                consumption_queue=consumption_queue
            )
        except (BrokerClientDataError, BrokerClientConnectionError) as error:
            logger.exception(error)

    async def _process_request(self,
                               response_exchange_name,
                               response_topic_name,
                               consumption_queue,
                               response_produce_method):
        while True:
            try:
                request_message_body = await consumption_queue.get()

                response_message_body = response_produce_method(request_message_body)

            except WorkerResponseError as error:
                logger.exception(error)
                response_message_body = compose_basic_error_landmark_get_response_body()

            try:
                await self._broker_client.send_message(
                    topic_name=response_topic_name,
                    exchange_name=response_exchange_name,
                    message_body=response_message_body
                )
            except (BrokerClientDataError, BrokerClientConnectionError) as error:
                logger.exception(error)
