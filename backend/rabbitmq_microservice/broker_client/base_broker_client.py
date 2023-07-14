from rabbitmq_microservice.producer.async_producer.topic_async_producer import TopicAsyncProducer
from rabbitmq_microservice.consumer.async_consumer.topic_async_consumer import TopicAsyncConsumer
from rabbitmq_microservice.consumer.async_consumer.base_async_consumer_util import ConsumptionMode


class BaseBrokerClient:
    def __init__(self, broker_host, broker_user, broker_password):
        self._broker_host = broker_host
        self._broker_user = broker_user
        self._broker_password = broker_password

    async def send_message(self, topic_name, exchange_name, message_body):
        producer = TopicAsyncProducer()
        await producer.open_connection(
            broker_host=self._broker_host,
            broker_user=self._broker_user,
            broker_password=self._broker_password
        )
        await producer.produce(topic=topic_name,
                               exchange_name=exchange_name,
                               message_body=message_body)
        print('sent message')

    async def consume_message(self, topic_name,
                              exchange_name,
                              callback,
                              consumption_queue,
                              consumption_mode=ConsumptionMode.NORMAL):
        consumer = TopicAsyncConsumer()
        await consumer.open_connection(
            broker_host=self._broker_host,
            broker_user=self._broker_user,
            broker_password=self._broker_password
        )

        print('opened connection')

        await consumer.consume(topic=topic_name,
                               exchange_name=exchange_name,
                               callback=callback,
                               callback_asyncio_queue=consumption_queue,
                               consumption_mode=consumption_mode)
