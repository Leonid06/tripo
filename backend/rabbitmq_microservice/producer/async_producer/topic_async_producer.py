from rabbitmq_microservice.producer.async_producer.base_async_producer import BaseAsyncProducer
from aio_pika import ExchangeType, Message, DeliveryMode

class TopicAsyncProducer(BaseAsyncProducer):
    def __init__(self, topic, exchange):
        super().__init__()
        self.__topic = topic
        self.__exchange = exchange

    async def produce(self, message_body):
        await self._channel.declare_exchange(self.__exchange, ExchangeType.TOPIC)
        message = Message(
            message_body,
            delivery_mode= DeliveryMode.PERSISTENT
        )

        self.__exchange.publish(message, routing_key = self.__topic)

    