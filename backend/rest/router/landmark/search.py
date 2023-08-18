import asyncio
import logging

from fastapi import APIRouter, HTTPException

from rest.schema.landmark.search import SearchLandmarkByRadiusIn, SearchLandmarkOut
from rest.config import RABBITMQ_USER, RABBITMQ_PASSWORD, RABBITMQ_HOST, \
    RABBITMQ_SEARCH_LANDMARK_BY_RADIUS_RESPONSE_TOPIC_NAME, RABBITMQ_SEARCH_LANDMARK_BY_RADIUS_REQUEST_TOPIC_NAME, \
    RABBITMQ_MAIN_EXCHANGE_NAME, SEARCH_LANDMARK_BY_ID_REQUEST_TIMEOUT
from rest.network_client.broker_network_client import BrokerNetworkClient
from rest.router.landmark.util.search_util import map_search_landmark_by_radius_inward_schema_to_message_body, \
    map_search_landmark_message_body_to_outward_schema, search_landmark_request_callback
from rest.exception import MappingError, NetworkClientDataError, NetworkClientBrokerError

landmark_search_router = APIRouter(
    prefix='/landmark/search',
    tags=['/landmark/search']
)

logger = logging.getLogger(__name__)


@landmark_search_router.post('/by-radius')
async def search_landmark_by_radius_endpoint(payload: SearchLandmarkByRadiusIn) -> SearchLandmarkOut:
    try:
        request_message_body = map_search_landmark_by_radius_inward_schema_to_message_body(payload)
    except MappingError as error:
        logger.exception(error)
        raise HTTPException(status_code=400, detail='Incorrect payload schema') from error

    try:
        broker_network_client = BrokerNetworkClient(
            broker_host=RABBITMQ_HOST,
            broker_user=RABBITMQ_USER,
            broker_password=RABBITMQ_PASSWORD
        )

        response_message_body = await asyncio.wait_for(
            broker_network_client.delegate_request_to_broker(
                message_body=request_message_body,
                request_topic_name=RABBITMQ_SEARCH_LANDMARK_BY_RADIUS_REQUEST_TOPIC_NAME,
                response_topic_name=RABBITMQ_SEARCH_LANDMARK_BY_RADIUS_RESPONSE_TOPIC_NAME,
                request_exchange_name=RABBITMQ_MAIN_EXCHANGE_NAME,
                response_exchange_name=RABBITMQ_MAIN_EXCHANGE_NAME,
                callback=search_landmark_request_callback
            ),
            timeout=int(SEARCH_LANDMARK_BY_ID_REQUEST_TIMEOUT)
        )
    except TypeError as error:
        logger.exception(error)
        raise HTTPException(status_code=500) from error
    except (asyncio.TimeoutError, NetworkClientBrokerError, NetworkClientDataError) as error:
        logger.exception(error)
        raise HTTPException(status_code=504) from error
    try:
        outward_schema = map_search_landmark_message_body_to_outward_schema(response_message_body)
    except MappingError as error:
        logger.exception(error)
        raise HTTPException(status_code=500) from error

    return outward_schema
