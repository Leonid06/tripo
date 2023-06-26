from celery.result import AsyncResult
from celery import chain
from fastapi import FastAPI

from celery_microservice.tasks import consume_get_all_landmarks_topic_task, produce_get_all_landmarks_topic_task, \
    retrieve_get_all_landmarks_topic_message_body_task
from postgresql_microservice.auth.authentication_setup import authentication_router, registration_router
from external_api_microservice.utils import generate_random_uuid

app = FastAPI()

app.include_router(
    router=authentication_router,
    prefix="/auth",
    tags=["Auth"],
)

app.include_router(
    router=registration_router,
    prefix="/auth",
    tags=["Auth"],
)


@app.get('/')
async def read_root():
    return {'Hello': 'World'}


@app.get('/landmarks/get/all')
async def get_all_landmarks(latitude: str, longitude: str, radius: str, query: str = ''):
    message_id = generate_random_uuid()

    consume_topic_message_task_chain = chain(consume_get_all_landmarks_topic_task.s(),
                                             retrieve_get_all_landmarks_topic_message_body_task.si(
                                                 message_id=message_id))()

    produce_get_all_landmarks_topic_task.delay(
        message_id=message_id,
        query=query,
        latitude=latitude,
        longitude=longitude,
        radius=radius
    )
    return {
        'response': 200,
        'message': 'request is in progress',
        'task_id': consume_topic_message_task_chain.id
    }


@app.get('/tasks/result')
async def get_task_status(task_id: str):
    task_result = AsyncResult(task_id)
    return {
        'task_id': task_id,
        'status': task_result.status,
        'result': task_result.result
    }

# @app.post('/registration', summary='Create user', response_model=schemas.UserOut)
# async def create_user(data: schemas.UserIn, db: Session = Depends(get_db)):
#     user = crud.get_user_by_email(email=data.email, db=db)
#     if user is not None:
#         raise HTTPException(
#             status_code=status.HTTP_400_BAD_REQUEST,
#             detail='User with this email already exist'
#         )
#     user = crud.create_user(data=data, db=db)
#     return {'email': user.email, 'id': user.id, 'is_active': user.is_active}
#
#
# @app.post('/token', response_model=schemas.Token)
# async def login_for_access_token(data: schemas.UserIn, db: Session = Depends(get_db)):
#     user = crud.get_user_by_inward_schema(data=data, db=db)
#     if not user:
#         raise HTTPException(
#             status_code=status.HTTP_401_UNAUTHORIZED,
#             detail='Incorrect username or password',
#             headers={'WWW-Authenticate': 'Bearer'},
#         )
#
#     access_token = crud.generate_access_token_for_user(user)
#     return {'access_token': access_token, 'token_type': 'bearer'}
