import json
from rabbitmq_microservice.consumers import TopicConsumer
from rabbitmq_microservice.producers import TopicProducer
from landmark_api_microservice.methods import get_landmarks
from config import RABBITMQ_MAIN_EXCHANGE_NAME, RABBITMQ_GET_ALL_LANDMARKS_REQUEST_TOPIC_NAME,\
    RABBITMQ_GET_ALL_LANDMARKS_RESPONSE_TOPIC_NAME


def callback(channel, method, properties, body):
    print(f'Landmark service consumer received message with body : {body}')
    channel.basic_ack(delivery_tag=method.delivery_tag)

    deserialized_body = json.loads(body)

    landmarks_data = get_landmarks(
        query=deserialized_body['query'],
        latitude=deserialized_body['latitude'],
        longitude=deserialized_body['longitude'],
        radius=deserialized_body['radius']
    )

    message_body = {
        'message_id': deserialized_body['message_id'],
        'data': landmarks_data
    }

    serialized_message_body = json.dumps(message_body)

    outward_producer = TopicProducer()
    outward_producer.topic = RABBITMQ_GET_ALL_LANDMARKS_RESPONSE_TOPIC_NAME
    outward_producer.exchange = RABBITMQ_MAIN_EXCHANGE_NAME
    outward_producer.open_connection()
    outward_producer.produce(message=serialized_message_body)
    outward_producer.close_connection()


def main():
    inward_consumer = TopicConsumer()
    inward_consumer.topic = RABBITMQ_GET_ALL_LANDMARKS_REQUEST_TOPIC_NAME
    inward_consumer.exchange = RABBITMQ_MAIN_EXCHANGE_NAME
    inward_consumer.open_connection()
    inward_consumer.consume(callback=callback)

    # result = get_landmarks(
    #     query= '',
    #     latitude= '40.177200',
    #     longitude= '44.503490',
    #     radius= '30000',
    # )
    pass


if __name__ == "__main__":
    main()
