
from fastapi import FastAPI
import os
from postgresql_microservice import crud, models
from postgresql_microservice.database import SessionLocal, engine
from dotenv import load_dotenv
from rabbitmq_microservice.producers import BaseProducer

load_dotenv()

models.Base.metadata.create_all(bind=engine)

app = FastAPI()

producer = BaseProducer(os.getenv('RABBITMQ_TEST_QUEUE_NAME'))

producer.produce('Sent message')

producer.close_connection()

@app.get('/')
def read_root():
    return {'Hello' : 'World'}





