import asyncio
import json
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from postgresql_microservice.dependencies import get_async_session
from postgresql_microservice.schemas.landmark.get import GetLandmarkIn, GetLandmarkOut
from rabbitmq_microservice.consumer.async_consumer.topic_async_consumer import TopicAsyncConsumer
from rabbitmq_microservice.producer.async_producer.topic_async_producer import TopicAsyncProducer
from external_api_microservice.config import RABBITMQ_MAIN_EXCHANGE_NAME, \
    RABBITMQ_LANDMARK_GET_BY_ID_REQUEST_TOPIC_NAME, RABBITMQ_LANDMARK_GET_BY_ID_RESPONSE_TOPIC_NAME
from external_api_microservice.routers.landmark.callback import get_landmark_by_id_broker_request_callback
from external_api_microservice.routers.landmark.util.get_util import map_get_landmark_inward_schema_to_message_body, \
    map_get_landmark_message_body_to_outward_schema

landmark_get_router = APIRouter(
    prefix='/landmark/get',
    tags=['/landmark/get']
)


@landmark_get_router.post('by-id')
async def get_landmark_by_id(payload: GetLandmarkIn, db: AsyncSession = Depends(get_async_session)) -> GetLandmarkOut:
    body = map_get_landmark_inward_schema_to_message_body(payload)
    producer = TopicAsyncProducer()
    await producer.open_connection()
    await producer.produce(topic=RABBITMQ_LANDMARK_GET_BY_ID_REQUEST_TOPIC_NAME,
                           exchange_name=RABBITMQ_MAIN_EXCHANGE_NAME,
                           message_body=json.dumps(body))

    consumer = TopicAsyncConsumer()
    consumption_queue = asyncio.Queue()
    await consumer.open_connection()
    await consumer.consume(topic=RABBITMQ_LANDMARK_GET_BY_ID_RESPONSE_TOPIC_NAME,
                           exchange_name=RABBITMQ_MAIN_EXCHANGE_NAME,
                           callback=get_landmark_by_id_broker_request_callback,
                           callback_asyncio_queue= consumption_queue)

    deserialized_message_body = await consumption_queue.get()
    outward_schema = map_get_landmark_message_body_to_outward_schema(deserialized_message_body)

    return outward_schema



