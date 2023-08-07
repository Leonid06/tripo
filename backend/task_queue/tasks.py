import json

from task_queue.main import app, redis
from task_queue.config import RABBITMQ_MAIN_EXCHANGE_NAME, \
    RABBITMQ_GET_ALL_LANDMARKS_REQUEST_TOPIC_NAME,\
    RABBITMQ_GET_ALL_LANDMARKS_RESPONSE_TOPIC_NAME
from broker.consumers import TopicConsumer
from broker.producers import TopicProducer



@app.task
def consume_get_all_landmarks_topic_task():
    inward_consumer = TopicConsumer()
    inward_consumer.topic = RABBITMQ_GET_ALL_LANDMARKS_RESPONSE_TOPIC_NAME
    inward_consumer.exchange = RABBITMQ_MAIN_EXCHANGE_NAME
    inward_consumer.open_connection()
    inward_consumer.consume(callback=get_all_landmarks_topic_message_callback)


@app.task
def produce_get_all_landmarks_topic_task(message_id: str, query: str, latitude: str, longitude: str, radius: str):
    message_data = {
        'message_id': message_id,
        'query': query,
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius
    }
    serialised_message_data = json.dumps(message_data)

    outward_producer = TopicProducer()
    outward_producer.topic = RABBITMQ_GET_ALL_LANDMARKS_REQUEST_TOPIC_NAME
    outward_producer.exchange = RABBITMQ_MAIN_EXCHANGE_NAME
    outward_producer.open_connection()
    outward_producer.produce(message=serialised_message_data)
    outward_producer.close_connection()


@app.task
def retrieve_get_all_landmarks_topic_message_body_task(message_id: str):
    body = redis.get(message_id)
    deserialized_body = json.loads(body)
    return deserialized_body


def get_all_landmarks_topic_message_callback(channel, method, properties, body):
    print(f'Celery consumer received message with body : {body}')
    channel.basic_ack(delivery_tag=method.delivery_tag)
    channel.stop_consuming()

    deserialized_body = json.loads(body)

    redis.set(deserialized_body['message_id'], body)
