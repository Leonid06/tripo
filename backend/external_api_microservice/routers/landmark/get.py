from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from postgresql_microservice.dependencies import get_async_session
from postgresql_microservice.schemas.landmark.get import GetLandmarkIn, GetLandmarkOut
from rabbitmq_microservice.consumers import TopicConsumer
from rabbitmq_microservice.producers import TopicProducer

from external_api_microservice.config import RABBITMQ_MAIN_EXCHANGE_NAME, \
    RABBITMQ_LANDMARK_GET_REQUEST_TOPIC_NAME


landmark_get_router = APIRouter(
    prefix='/landmark/get',
    tags=['/landmark/get']
)


@landmark_get_router.post('by-id')
async def get_landmark_by_id(payload : GetLandmarkIn, db : AsyncSession = Depends(get_async_session)) -> GetLandmarkOut:
    pass