from dotenv import load_dotenv
from celery_microservice.main import app, redis
import os
import json
from rabbitmq_microservice.consumers import TopicConsumer
from rabbitmq_microservice.producers import TopicProducer
from typing import Dict

load_dotenv()


@app.task
def consume_test_topic_message_task():
    inward_consumer = TopicConsumer()
    inward_consumer.topic = os.getenv('RABBITMQ_INWARD_TOPIC_NAME')
    inward_consumer.exchange = os.getenv('RABBITMQ_TEST_EXCHANGE_NAME')
    inward_consumer.open_connection()
    inward_consumer.consume(callback=test_topic_message_callback)

@app.task
def produce_test_topic_message_task(message_id : str, query : str, latitude: str, longitude : str, radius : str):
    message_data = {
        'message_id' : message_id,
        'query' : query,
        'latitude' : latitude,
        'longitude' : longitude,
        'radius' : radius
    }
    serialised_message_data = json.dumps(message_data)

    outward_producer = TopicProducer()
    outward_producer.topic = os.getenv('RABBITMQ_OUTWARD_TOPIC_NAME')
    outward_producer.exchange = os.getenv('RABBITMQ_TEST_EXCHANGE_NAME')
    outward_producer.open_connection()
    outward_producer.produce(message=serialised_message_data)
    outward_producer.close_connection()

@app.task
def retrieve_test_topic_message_body_task(message_id : str):
    body = redis.get(message_id)
    deserialized_body = json.loads(body)
    return deserialized_body

def test_topic_message_callback(channel, method, properties, body):
    print(f'Celery consumer received message with body : {body}')
    channel.basic_ack(delivery_tag=method.delivery_tag)
    channel.stop_consuming()

    deserialized_body = json.loads(body)

    redis.set(deserialized_body['message_id'], body)



