import os
import sys
from sqlalchemy.orm import Session
from postgresql_microservice.dependencies import get_db
from fastapi import FastAPI, status, HTTPException, Depends
from celery.result import AsyncResult
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from postgresql_microservice import crud, models, schemas
from postgresql_microservice.database import engine
from celery_microservice.tasks import consume_test_topic_message_task, produce_test_topic_message_task, retrieve_test_topic_message_body_task
from dotenv import load_dotenv
from external_api_microservice.utils import generate_random_uuid
from typing import Annotated
from celery import chain

load_dotenv()

models.Base.metadata.create_all(bind=engine)

app = FastAPI()

@app.get('/')
async def read_root():
    return {'Hello': 'World'}


@app.post('/registration', summary='Create user', response_model=schemas.UserOut)
async def create_user(data: schemas.UserIn, db: Session = Depends(get_db)):
    user = crud.get_user_by_email(email=data.email, db=db)
    if user is not None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail='User with this email already exist'
        )
    user = crud.create_user(data=data, db=db)
    return {'email' : user.email, 'id' : user.id, 'is_active' : user.is_active}


@app.post('/token', response_model=schemas.Token)
async def login_for_access_token(data: schemas.UserIn, db: Session = Depends(get_db)):
    user = crud.get_user_by_inward_schema(data=data, db=db)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail='Incorrect username or password',
            headers={'WWW-Authenticate': 'Bearer'},
        )

    access_token = crud.generate_access_token_for_user(user)
    return {'access_token': access_token, 'token_type': 'bearer'}

@app.get('/landmarks/get/all')
async def get_all_landmarks(latitude : str, longitude : str, radius : str, query : str = ''):
    message_id = generate_random_uuid()

    consume_topic_message_task_chain = chain(consume_test_topic_message_task.s(), retrieve_test_topic_message_body_task.si(message_id = message_id))()

    produce_test_topic_message_task.delay(
        message_id=message_id,
        query = query,
        latitude = latitude,
        longitude = longitude,
        radius = radius
    )
    return {
        'response' : 200,
        'message' : 'request is in progress',
        'task_id' : consume_topic_message_task_chain.id
    }

@app.get('/tasks/result')
async def get_task_status(task_id : str):
    task_result = AsyncResult(task_id)
    return {
        'task_id' : task_id,
        'status' : task_result.status,
        'result' : task_result.result
    }
