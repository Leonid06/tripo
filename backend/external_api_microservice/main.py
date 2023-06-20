import os
import sys
from sqlalchemy.orm import Session
from postgresql_microservice.dependencies import get_db
from fastapi import FastAPI, status, HTTPException, Depends
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from postgresql_microservice import crud, models, schemas
from postgresql_microservice.database import engine
from celery_microservice.tasks import topic_test_task
from dotenv import load_dotenv
from typing import Annotated

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

@app.get('/topic-test')
async def topic_test():
    topic_test_task.delay()
    return {
        'status' : 200,
        'data' : 'Topic test task started'
    }
