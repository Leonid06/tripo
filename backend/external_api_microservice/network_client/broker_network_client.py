import asyncio

from external_api_microservice.routers.landmark.callback import get_landmark_by_id_broker_request_callback
from external_api_microservice.exception import CallbackDataError, NetworkClientDataError, NetworkClientBrokerError

from rabbitmq_microservice.broker_client.base_broker_client import BaseBrokerClient
from rabbitmq_microservice.consumer.async_consumer.base_async_consumer_util import ConsumptionMode
from rabbitmq_microservice.exception import BrokerClientDataError, BrokerClientConnectionError


class BrokerNetworkClient:
    def __init__(self, broker_host, broker_user, broker_password):
        self.__broker_host = broker_host
        self.__broker_user = broker_user
        self.__broker_password = broker_password

    async def delegate_get_landmark_by_id_request_to_broker(self, message_body,
                                                            request_topic_name,
                                                            response_topic_name,
                                                            request_exchange_name,
                                                            response_exchange_name
                                                            ):
        response_consumption_queue = asyncio.Queue()

        try:
            broker_client = BaseBrokerClient(
                broker_host=self.__broker_host,
                broker_user=self.__broker_user,
                broker_password=self.__broker_password
            )
        except TypeError as error:
            raise NetworkClientDataError from error

        try:
            await asyncio.gather(
                broker_client.send_message(
                    topic_name=request_topic_name,
                    exchange_name='rabbitmq_main_exchange_name',
                    message_body=message_body
                ),
                broker_client.consume_message(
                    topic_name=response_topic_name,
                    exchange_name='rabbitmq_main_exchange_name',
                    callback=get_landmark_by_id_broker_request_callback,
                    consumption_queue=response_consumption_queue,
                    consumption_mode=ConsumptionMode.CANCEL_ON_FIRST_MESSAGE
                )
            )
        except CallbackDataError as error:
            raise NetworkClientDataError from error
        except (BrokerClientConnectionError, BrokerClientDataError) as error:
            raise NetworkClientBrokerError from error

        message_body = await response_consumption_queue.get()

        return message_body
