from rabbitmq_microservice.consumer.async_consumer.base_async_consumer import BaseAsyncConsumer
from aio_pika import ExchangeType
from aio_pika.abc import AbstractIncomingMessage


class TopicAsyncConsumer(BaseAsyncConsumer):

    async def consume(self, topic, exchange_name, callback, callback_asyncio_queue):
        exchange = await self._channel.declare_exchange(
            exchange_name, ExchangeType.TOPIC
        )
        queue = await self._channel.declare_queue(name='')

        await queue.bind(exchange=exchange, routing_key=topic)

        async with queue.iterator() as iterator:
            message: AbstractIncomingMessage
            async for message in iterator:
                async with message.process():
                    callback(queue, message.body, callback_asyncio_queue)
