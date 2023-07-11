import asyncio

from rabbitmq_microservice.producer.async_producer.topic_async_producer import TopicAsyncProducer
from rabbitmq_microservice.consumer.async_consumer.topic_async_consumer import TopicAsyncConsumer


def test_topic_async_producer():
    async def main():
        topic = 'test'
        exchange_name  = 'exchange'
        message_body = b'Test message 1'

        producer = TopicAsyncProducer()
        await producer.open_connection()
        await producer.produce(topic=topic,
                               exchange_name=exchange_name,
                               message_body=message_body)

    asyncio.run(main())



def test_async_actors():

    def callback(queue, message_body):
        print(f'Received message with body: {message_body}')
        queue.cancel()

    async def main():

        topic = 'test'
        exchange_name = 'exchange'
        message_body = b'Test message 2'

        producer = TopicAsyncProducer()

        await producer.open_connection()
        await producer.produce(topic=topic,
                               exchange_name=exchange_name,
                               message_body=message_body)

        consumer = TopicAsyncConsumer()
        await consumer.open_connection()
        await consumer.consume(topic=topic, exchange_name=exchange_name, callback=callback)

    asyncio.run(main())


