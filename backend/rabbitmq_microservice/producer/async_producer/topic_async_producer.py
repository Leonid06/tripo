from rabbitmq_microservice.producer.async_producer.base_async_producer import BaseAsyncProducer
from aio_pika import ExchangeType, Message, DeliveryMode


class TopicAsyncProducer(BaseAsyncProducer):
    async def produce(self, topic, exchange_name, message_body):
        exchange = await self._channel.declare_exchange(exchange_name, ExchangeType.TOPIC)
        message = Message(
            message_body,
            delivery_mode=DeliveryMode.PERSISTENT
        )
        await exchange.publish(message, routing_key=topic)

