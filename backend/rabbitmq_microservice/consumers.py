import pika
import os
from dotenv import load_dotenv


load_dotenv()

class BaseConsumer:
    def __init__(self, queue_name):
        self.__exchange_type = ''
        self.__host = os.getenv('RABBITMQ_HOST')
        self.__connection = pika.BlockingConnection(pika.ConnectionParameters(host=self.__host))
        self.__channel = self.__connection.channel()
        self.__queue_name = queue_name
        self.__channel.queue_declare(queue=self.__queue_name)

    def consume(self, callback):
        self.__channel.basic_consume(
            queue=self.__queue_name,
            on_message_callback=callback
        )
        self.__channel.start_consuming()
