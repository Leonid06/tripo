
from fastapi import FastAPI, status, HTTPException
from postgresql_microservice import crud, models, schemas
from postgresql_microservice.database import engine
from dotenv import load_dotenv




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
            detail="User with this email already exist"
        )

    return crud.create_user(data=data)













