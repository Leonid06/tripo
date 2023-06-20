import pika
from pika.exceptions import  AMQPError
import os
from dotenv import load_dotenv

load_dotenv()


class BaseConsumer:
    def __init__(self, queue_name=''):
        self._exchange_type = ''
        self._host = os.getenv('RABBITMQ_HOST')
        self._queue_name = queue_name
        self._connection = None
        self._channel = None

    def consume(self, callback):
        try:
            self._channel.queue_declare(queue=self._queue_name)
            self._channel.basic_consume(
                queue=self._queue_name,
                on_message_callback=callback
            )
            self._channel.start_consuming()
        except AMQPError as amqpError :
            pass

    def open_connection(self):
        try:
            self._connection = pika.BlockingConnection(pika.ConnectionParameters(host=self._host))
            self._channel = self._connection.channel()
        except AMQPError as amqpError :
            pass

    def close_connection(self):
        try:
            self._connection.close()
        except AMQPError as amqpError :
            pass

    @property
    def queue_name(self):
        return self._queue_name

    @queue_name.setter
    def queue_name(self, value):
        self._queue_name = value


class TopicConsumer(BaseConsumer):

    def __init__(self, topic= None, exchange = None):
        super().__init__()
        self.__topic = topic
        self.__exchange = exchange

    def consume(self, callback):
        try:
            self._channel.exchange_declare(exchange = self.__exchange, exchange_type= 'topic')
            result = self._channel.queue_declare(queue= '', exclusive= True)
            queue_name = result.method.queue

            self._channel.queue_bind(
                exchange= self.__exchange,
                queue= queue_name,
                routing_key= self.__topic)

            self._channel.basic_consume(
                queue = queue_name, on_message_callback = callback
            )

            self._channel.start_consuming()
        except AMQPError as amqpError :
            pass

    def stop_consuming(self):
        self._channel.stop_consuming()

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

