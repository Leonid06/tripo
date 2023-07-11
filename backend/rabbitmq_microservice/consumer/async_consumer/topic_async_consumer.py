from rabbitmq_microservice.consumer.async_consumer.base_async_consumer import BaseAsyncConsumer


class TopicAsyncConsumer(BaseAsyncConsumer):
    def __init__(self, topic, exchange):
        super().__init__()
        self.__topic = topic
        self.__exchange = exchange

