from dotenv import load_dotenv
from celery_microservice.main import app
import os
from rabbitmq_microservice.consumers import TopicConsumer
from rabbitmq_microservice.producers import TopicProducer

load_dotenv()


@app.task
def consume_test_topic_message_task():
    inward_consumer = TopicConsumer()
    inward_consumer.topic = os.getenv('RABBITMQ_INWARD_TOPIC_NAME')
    inward_consumer.exchange = os.getenv('RABBITMQ_TEST_EXCHANGE_NAME')
    inward_consumer.open_connection()
    inward_consumer.consume(callback=consume_test_topic_message_task_callback)

@app.task
def produce_test_topic_message_task():
    outward_producer = TopicProducer()
    outward_producer.topic = os.getenv('RABBITMQ_OUTWARD_TOPIC_NAME')
    outward_producer.exchange = os.getenv('RABBITMQ_TEST_EXCHANGE_NAME')
    outward_producer.open_connection()
    outward_producer.produce(message='Message from celery producer to landmark api service consumer')
    outward_producer.close_connection()


def consume_test_topic_message_task_callback(channel, method, properties, body):
    print(f'Celery consumer received message with body : {body}')
    channel.basic_ack(delivery_tag=method.delivery_tag)
    channel.stop_consuming()



