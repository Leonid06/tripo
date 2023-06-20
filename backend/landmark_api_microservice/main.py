import os
# import json
# import requests
from rabbitmq_microservice.consumers import TopicConsumer
from rabbitmq_microservice.producers import TopicProducer
from dotenv import load_dotenv


def configure():
    load_dotenv()


def callback(channel, method, properties, body):
    print(f'Landmark service consumer received message with body : {body}')
    channel.basic_ack(delivery_tag=method.delivery_tag)

    outward_producer = TopicProducer()
    outward_producer.topic = os.getenv('RABBITMQ_INWARD_TOPIC_NAME')
    outward_producer.exchange = os.getenv('RABBITMQ_TEST_EXCHANGE_NAME')
    outward_producer.open_connection()
    outward_producer.produce(message='Message from landmark service producer to celery consumer')
    outward_producer.close_connection()


def main():
    configure()

    # consumer = BaseConsumer(os.getenv('RABBITMQ_TEST_QUEUE_NAME'))
    #
    # consumer.consume(callback=test_callback)

    # base_url = os.getenv('BASE_URL')
    # api_key = os.getenv('TOMTOM_API_KEY')
    #
    # latitude = 36.8709
    # longitude = 30.5229
    # category_set = 7376
    # radius = 20000
    # response = requests.get(f'{base_url}search/2/nearbySearch/.json?key={api_key}&lat={latitude}&lon={longitude}&categorySet={category_set}&radius={radius}')
    #
    # deserialized_data = json.loads(response.text)
    # print(deserialized_data)

    inward_consumer = TopicConsumer()
    inward_consumer.topic = os.getenv('RABBITMQ_OUTWARD_TOPIC_NAME')
    inward_consumer.exchange = os.getenv('RABBITMQ_TEST_EXCHANGE_NAME')
    inward_consumer.open_connection()
    inward_consumer.consume(callback=callback)


if __name__ == "__main__":
    main()
