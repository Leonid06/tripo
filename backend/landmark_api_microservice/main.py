import os
import json
import requests
from dotenv import load_dotenv
from rabbitmq_microservice.consumers import BaseConsumer

def configure():
    load_dotenv()


def test_callback(ch, method, properties, body):
    print(f'Received message : {body}')

def main():
    configure()

    consumer = BaseConsumer(os.getenv('RABBITMQ_TEST_QUEUE_NAME'))

    consumer.consume(callback=test_callback)

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

if __name__ == "__main__" :
    main()