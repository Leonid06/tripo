import asyncio
from datasource.worker.search_worker import SearchWorker
from datasource.config import BASE_URL, API_KEY, \
    RABBITMQ_LANDMARK_GET_BY_ID_RESPONSE_TOPIC_NAME, RABBITMQ_LANDMARK_GET_BY_ID_REQUEST_TOPIC_NAME, \
    RABBITMQ_MAIN_EXCHANGE_NAME, REDIS_HOST, REDIS_PORT, RABBITMQ_HOST, RABBITMQ_USER, RABBITMQ_PASSWORD


async def main():
    worker = SearchWorker(api_key=API_KEY,
                          base_url=BASE_URL,
                          cacher_host=REDIS_HOST,
                          cacher_port=REDIS_PORT,
                          broker_host=RABBITMQ_HOST,
                          broker_user=RABBITMQ_USER,
                          broker_password=RABBITMQ_PASSWORD
                          )

    await worker.subscribe_to_landmark_get_request(
        request_exchange_name=RABBITMQ_MAIN_EXCHANGE_NAME,
        response_exchange_name=RABBITMQ_MAIN_EXCHANGE_NAME,
        request_topic_name=RABBITMQ_LANDMARK_GET_BY_ID_REQUEST_TOPIC_NAME,
        response_topic_name=RABBITMQ_LANDMARK_GET_BY_ID_RESPONSE_TOPIC_NAME
    )


if __name__ == '__main__':
    asyncio.run(main())
