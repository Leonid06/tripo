import os

from celery import Celery
from dotenv import load_dotenv
import redis

load_dotenv()

CELERY_APPLICATION_NAME = os.getenv('CELERY_APPLICATION_NAME')
CELERY_BROKER_PROTOCOL = os.getenv('CELERY_BROKER_PROTOCOL')
CELERY_BROKER_HOST = os.getenv('CELERY_BROKER_HOST')
CELERY_BROKER_PORT = os.getenv('CELERY_BROKER_PORT')
REDIS_HOST = os.getenv('REDIS_HOST')
REDIS_PORT = os.getenv('REDIS_PORT')

BROKER_URL = f'{CELERY_BROKER_PROTOCOL}://{CELERY_BROKER_HOST}:{CELERY_BROKER_PORT}'


app = Celery(main='tasks',
    broker= BROKER_URL,
    backend= BROKER_URL)

redis = redis.Redis(host= REDIS_HOST, port = REDIS_PORT, decode_responses= True)

app.conf.update(
    CELERY_IMPORTS = ('celery_microservice.tasks')
)



