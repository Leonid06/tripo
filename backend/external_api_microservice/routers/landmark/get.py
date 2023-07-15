import asyncio
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from postgresql_microservice.dependencies import get_async_session
from postgresql_microservice.schemas.landmark.get import GetLandmarkIn, GetLandmarkOut
from external_api_microservice.config import RABBITMQ_MAIN_EXCHANGE_NAME, \
    RABBITMQ_LANDMARK_GET_BY_ID_REQUEST_TOPIC_NAME, RABBITMQ_LANDMARK_GET_BY_ID_RESPONSE_TOPIC_NAME, \
    RABBITMQ_USER, RABBITMQ_PASSWORD, RABBITMQ_HOST
from external_api_microservice.routers.landmark.callback import get_landmark_by_id_broker_request_callback
from external_api_microservice.routers.landmark.util.get_util import map_get_landmark_inward_schema_to_message_body, \
    map_get_landmark_message_body_to_outward_schema
from rabbitmq_microservice.broker_client.base_broker_client import BaseBrokerClient
from rabbitmq_microservice.consumer.async_consumer.base_async_consumer_util import ConsumptionMode

landmark_get_router = APIRouter(
    prefix='/landmark/get',
    tags=['/landmark/get']
)


@landmark_get_router.post('by-id')
async def get_landmark_by_id(payload: GetLandmarkIn, db: AsyncSession = Depends(get_async_session)) -> GetLandmarkOut:
    body = map_get_landmark_inward_schema_to_message_body(payload)
    broker_client = BaseBrokerClient(
        broker_host=RABBITMQ_HOST,
        broker_user=RABBITMQ_USER,
        broker_password=RABBITMQ_PASSWORD
    )
    consumption_queue = asyncio.Queue()

    print(RABBITMQ_LANDMARK_GET_BY_ID_REQUEST_TOPIC_NAME)

    await asyncio.gather(
        broker_client.send_message(
            topic_name=RABBITMQ_LANDMARK_GET_BY_ID_REQUEST_TOPIC_NAME,
            exchange_name='rabbitmq_main_exchange_name',
            message_body=body
        ),
        broker_client.consume_message(
            topic_name=RABBITMQ_LANDMARK_GET_BY_ID_RESPONSE_TOPIC_NAME,
            exchange_name='rabbitmq_main_exchange_name',
            callback=get_landmark_by_id_broker_request_callback,
            consumption_queue=consumption_queue,
            consumption_mode=ConsumptionMode.CANCEL_ON_FIRST_MESSAGE
        )
    )
    message_body = await consumption_queue.get()

    outward_schema = map_get_landmark_message_body_to_outward_schema(message_body)

    return outward_schema



