import asyncio
from landmark_api_microservice.worker.search_worker import SearchWorker
from landmark_api_microservice.config import BASE_URL, API_KEY, \
    RABBITMQ_GET_ALL_LANDMARKS_RESPONSE_TOPIC_NAME, RABBITMQ_GET_ALL_LANDMARKS_REQUEST_TOPIC_NAME, \
    RABBITMQ_MAIN_EXCHANGE_NAME, REDIS_HOST, REDIS_PORT


async def main():
    worker = SearchWorker(api_key=API_KEY,
                          base_url=BASE_URL,
                          cacher_host=REDIS_HOST,
                          cacher_port=REDIS_PORT
                          )
    await worker.handle_landmark_get_request(
        request_exchange_name=RABBITMQ_MAIN_EXCHANGE_NAME,
        response_exchange_name=RABBITMQ_MAIN_EXCHANGE_NAME,
        request_topic_name=RABBITMQ_GET_ALL_LANDMARKS_REQUEST_TOPIC_NAME,
        response_topic_name=RABBITMQ_GET_ALL_LANDMARKS_RESPONSE_TOPIC_NAME
    )


if __name__ == '__main__':
    asyncio.run(main())
