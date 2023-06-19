from dotenv import load_dotenv
from celery_microservice.main import app
import os
from rabbitmq_microservice.consumers import TopicConsumer
from rabbitmq_microservice.producers import TopicProducer

load_dotenv()

@app.task
def topic_test_task():
    outward_producer = TopicProducer()
    outward_producer.topic = os.getenv('RABBITMQ_OUTWARD_TOPIC_NAME')
    outward_producer.exchange = os.getenv('RABBITMQ_TEST_EXCHANGE_NAME')
    outward_producer.open_connection()
    outward_producer.produce(message='Message from celery producer to landmark api service consumer')

    inward_consumer = TopicConsumer()
    inward_consumer.topic = os.getenv('RABBITMQ_INWARD_TOPIC_NAME')
    inward_consumer.exchange = os.getenv('RABBITMQ_TEST_EXCHANGE_NAME')
    inward_consumer.open_connection()
    inward_consumer.consume(callback=lambda channel, method, properties, body: print(
        f'Celery consumer received message with body : {body}'
    ))


