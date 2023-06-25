from celery import Celery
import redis

from celery_microservice.config import CELERY_BROKER_PROTOCOL, \
    CELERY_BROKER_HOST, CELERY_BROKER_PORT, REDIS_HOST, REDIS_PORT, CELERY_APPLICATION_NAME

BROKER_URL = f'{CELERY_BROKER_PROTOCOL}://{CELERY_BROKER_HOST}:{CELERY_BROKER_PORT}'

app = Celery(main=CELERY_APPLICATION_NAME,
             broker=BROKER_URL,
             backend=BROKER_URL)

redis = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)

app.conf.update(
    CELERY_IMPORTS=('celery_microservice.tasks')
)
