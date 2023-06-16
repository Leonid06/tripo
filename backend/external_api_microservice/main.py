import sys

from fastapi import FastAPI, status, HTTPException, Depends
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from postgresql_microservice import crud, models, schemas
from postgresql_microservice.database import engine
from dotenv import load_dotenv
from typing import Annotated






load_dotenv()

models.Base.metadata.create_all(bind=engine)

app = FastAPI()

# producer = BaseProducer(os.getenv('RABBITMQ_TEST_QUEUE_NAME'))
#
# producer.produce('Sent message')
#
# producer.close_connection()

@app.get('/')
def read_root():
    return {'Hello' : 'World'}

@app.post('/registration', summary='Create user', response_model= schemas.UserOut)
def create_user(data: schemas.UserIn):
    user = crud.get_user_by_email(email= data.email)
    if user is not None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail='User with this email already exist'
        )

    return crud.create_user(data=data)


@app.post('/token', response_model=schemas.Token)
def login_for_access_token(data : schemas.UserIn):
    user = crud.get_user_by_inward_schema(data = data)
    if not user :
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail='Incorrect username or password',
            headers={'WWW-Authenticate': 'Bearer'},
        )

    access_token = crud.generate_access_token_for_user(user)
    return {'access_token' : access_token, 'token_type' : 'bearer'}
















