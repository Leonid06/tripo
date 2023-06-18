import pika
from pika.exceptions import  AMQPError
import os
from dotenv import load_dotenv

load_dotenv()

class BaseProducer:
    def __init__(self, queue_name = ''):
        self.__exchange_type = ''
        self.__host = os.getenv('RABBITMQ_HOST')
        self.__queue_name = queue_name
        self.__connection = None
        self.__channel = None

    def produce(self, message):
        try:
            self.__channel.basic_publish(
                exchange=self.__exchange_type,
                routing_key=self.__queue_name,
                body=message)
        except AMQPError as amqpError:
            pass

    def open_connection(self):
        try:
            self.__connection = pika.BlockingConnection(pika.ConnectionParameters(host=self.__host))
            self.__channel = self.__connection.channel()
        except AMQPError as amqpError:
            pass

    def close_connection(self):
        try:
            self.__connection.close()
        except AMQPError as amqpError:
            pass

    @property
    def queue_name(self):
        return self.__queue_name

    @queue_name.setter
    def queue_name(self, value):
        self.__queue_name = value

class TopicProducer(BaseProducer):

    def __init__(self, topic= None, exchange = None):
        super().__init__()
        self.__topic = topic
        self.__exchange = exchange

    def produce(self, message):
        try:
            self.__channel.exchange_declare(exchange=self.__exchange, exchange_type='topic')
            self.__channel.basic_publish(
                exchange= self.__exchange,
                routing_key= self.__topic,
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
