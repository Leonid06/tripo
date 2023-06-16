import pika
import os
from dotenv import load_dotenv

load_dotenv()

class BaseProducer:
    def __init__(self, queue_name):
        self.__exchange_type = ''
        self.__host = os.getenv('RABBITMQ_HOST')
        self.__connection = pika.BlockingConnection(pika.ConnectionParameters(host=self.__host))
        self.__channel = self.__connection.channel()
        self.__queue_name = queue_name
        self.__channel.queue_declare(queue=self.__queue_name)

    def produce(self, message):
        self.__channel.basic_publish(
            exchange=self.__exchange_type,
            routing_key=self.__queue_name,
            body=message)

    def close_connection(self):
        self.__connection.close()
