import asyncio
import logging

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from rest.network_client.broker_network_client import BrokerNetworkClient
from rest.config import LANDMARK_GET_BY_ID_REQUEST_TIMEOUT, RABBITMQ_MAIN_EXCHANGE_NAME, \
    RABBITMQ_LANDMARK_GET_BY_ID_REQUEST_TOPIC_NAME, RABBITMQ_LANDMARK_GET_BY_ID_RESPONSE_TOPIC_NAME, \
    RABBITMQ_USER, RABBITMQ_PASSWORD, RABBITMQ_HOST
from rest.routers.landmark.util.get_util import map_get_landmark_inward_schema_to_message_body, \
    map_get_landmark_message_body_to_outward_schema
from rest.exception import MappingError, NetworkClientDataError, NetworkClientBrokerError

from db.dependencies import get_async_session
from db.schemas.landmark.get import GetLandmarkIn, GetLandmarkOut

landmark_get_router = APIRouter(
    prefix='/landmark/get',
    tags=['/landmark/get']
)

logger = logging.getLogger(__name__)


@landmark_get_router.post('/by-id')
async def get_landmark_by_id(payload: GetLandmarkIn, db: AsyncSession = Depends(get_async_session)) -> GetLandmarkOut:
    try:
        request_message_body = map_get_landmark_inward_schema_to_message_body(payload)
    except MappingError as error:
        logger.exception(error)
        raise HTTPException(status_code=400, detail = 'Incorrect payload schema') from error

    try:
        broker_network_client = BrokerNetworkClient(
            broker_host=RABBITMQ_HOST,
            broker_user=RABBITMQ_USER,
            broker_password=RABBITMQ_PASSWORD
        )
        response_message_body = await asyncio.wait_for(
            broker_network_client.delegate_get_landmark_by_id_request_to_broker(
                message_body=request_message_body,
                request_topic_name= RABBITMQ_LANDMARK_GET_BY_ID_REQUEST_TOPIC_NAME,
                response_topic_name= RABBITMQ_LANDMARK_GET_BY_ID_RESPONSE_TOPIC_NAME,
                request_exchange_name=RABBITMQ_MAIN_EXCHANGE_NAME,
                response_exchange_name=RABBITMQ_MAIN_EXCHANGE_NAME
            ),
            timeout= int(LANDMARK_GET_BY_ID_REQUEST_TIMEOUT))

    except TypeError as error:
        logger.exception(error)
        raise HTTPException(status_code=500) from error
    except (asyncio.TimeoutError, NetworkClientBrokerError, NetworkClientDataError) as error:
        logger.exception(error)
        raise HTTPException(status_code=504) from error
    try:
        outward_schema = map_get_landmark_message_body_to_outward_schema(response_message_body)
    except MappingError as error:
        logger.exception(error)
        raise HTTPException(status_code=500) from error

    return outward_schema



