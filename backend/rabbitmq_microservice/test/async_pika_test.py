import asyncio

from rabbitmq_microservice.producer.async_producer.topic_async_producer import TopicAsyncProducer


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


