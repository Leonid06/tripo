import pika
from pika.exceptions import AMQPError
from config import RABBITMQ_HOST


class BaseProducer:
    def __init__(self, queue_name=''):
        self._exchange_type = ''
        self._host = RABBITMQ_HOST
        self._queue_name = queue_name
        self._connection = None
        self._channel = None

    def produce(self, message):
        try:
            self._channel.basic_publish(
                exchange=self._exchange_type,
                routing_key=self._queue_name,
                body=message)
        except AMQPError as amqpError:
            pass

    def open_connection(self):
        try:
            self._connection = pika.BlockingConnection(pika.ConnectionParameters(host=self._host))
            self._channel = self._connection.channel()
        except AMQPError as amqpError:
            pass

    def close_connection(self):
        try:
            self._connection.close()
        except AMQPError as amqpError:
            pass

    @property
    def queue_name(self):
        return self._queue_name

    @queue_name.setter
    def queue_name(self, value):
        self._queue_name = value


class TopicProducer(BaseProducer):

    def __init__(self, topic=None, exchange=None):
        super().__init__()
        self.__topic = topic
        self.__exchange = exchange

    def produce(self, message):
        try:
            self._channel.exchange_declare(exchange=self.__exchange, exchange_type='topic')
            self._channel.basic_publish(
                exchange=self.__exchange,
                routing_key=self.__topic,
                body=message
            )
        except AMQPError as amqpError:
            pass

    @property
    def topic(self):
        return self.__topic

    @topic.setter
    def topic(self, value):
        self.__topic = value

    @property
    def exchange(self):
        return self.__exchange

    @exchange.setter
    def exchange(self, value):
        self.__exchange = value
