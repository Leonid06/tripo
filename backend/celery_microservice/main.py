import os

from celery import Celery
from dotenv import load_dotenv

load_dotenv()

CELERY_APPLICATION_NAME = os.getenv('CELERY_APPLICATION_NAME')
CELERY_BROKER_PROTOCOL = os.getenv('CELERY_BROKER_PROTOCOL')
CELERY_BROKER_HOST = os.getenv('CELERY_BROKER_HOST')
CELERY_BROKER_PORT = os.getenv('CELERY_BROKER_PORT')


app = Celery(
    CELERY_APPLICATION_NAME,
    broker= f'{CELERY_BROKER_PROTOCOL}://{CELERY_BROKER_HOST}:{CELERY_BROKER_PORT}')



