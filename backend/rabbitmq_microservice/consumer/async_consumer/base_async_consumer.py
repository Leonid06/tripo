from aio_pika import connect
from rabbitmq_microservice.consumer.async_consumer.base_async_consumer_util import ConsumptionMode

class BaseAsyncConsumer:
    def __init__(self):
        self._connection = None
        self._channel = None

    async def open_connection(self, broker_user, broker_password, broker_host):
        self._connection = await connect(f'amqp://{broker_user}:{broker_password}@{broker_host}/')
        self._channel = await self._connection.channel()
