import pika
from pika.exceptions import  AMQPError
import os
from dotenv import load_dotenv

load_dotenv()


class BaseConsumer:
    def __init__(self, queue_name=''):
        self.__exchange_type = ''
        self.__host = os.getenv('RABBITMQ_HOST')
        self.__queue_name = queue_name
        self.__connection = None
        self.__channel = None

    def consume(self, callback):
        try:
            self.__channel.queue_declare(queue=self.__queue_name)
            self.__channel.basic_consume(
                queue=self.__queue_name,
                on_message_callback=callback
            )
            self.__channel.start_consuming()
        except AMQPError as amqpError :
            pass

    def open_connection(self):
        try:
            self.__connection = pika.BlockingConnection(pika.ConnectionParameters(host=self.__host))
            self.__channel = self.__connection.channel()
        except AMQPError as amqpError :
            pass

    def close_connection(self):
        try:
            self.__connection.close()
        except AMQPError as amqpError :
            pass

    @property
    def queue_name(self):
        return self.__queue_name

    @queue_name.setter
    def queue_name(self, value):
        self.__queue_name = value


class TopicConsumer(BaseConsumer):

    def __init__(self, topic= None, exchange = None):
        super().__init__()
        self.__topic = topic
        self.__exchange = exchange

    def consume(self, callback):
        try:
            self.__channel.exchange_declare(exchange = self.__exchange, exchange_type= 'topic')
            result = self.__channel.queue_declare(queue= '', exclusive= True)
            queue_name = result.method.queue

            self.__channel.queue_bind(
                exchange= self.__exchange,
                queue= queue_name,
                routing_key= self.__topic)

            self.__channel.basic_consume(
                queue = queue_name, on_message = callback
            )

            self.__channel.start_consuming()
        except AMQPError as amqpError :
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
