from aio_pika import connect
from rabbitmq_microservice.config import RABBITMQ_HOST, RABBITMQ_USER, RABBITMQ_PASSWORD


class BaseAsyncConsumer:
    def __init__(self):
        self._connection = None
        self._channel = None

    async def open_connection(self):
        self._connection = await connect(f'amqp://{RABBITMQ_USER}:{RABBITMQ_PASSWORD}@{RABBITMQ_HOST}/')
        self._channel = await self._connection.channel()
