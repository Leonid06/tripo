from fastapi_users.authentication import BearerTransport, AuthenticationBackend
from fastapi_users import FastAPIUsers

from postgresql_microservice.dependencies import get_user_manager
from postgresql_microservice.models import User
from postgresql_microservice.schemas import  UserRead, UserCreate
from postgresql_microservice.dependencies import get_jwt_strategy

bearer_transport = BearerTransport(tokenUrl='auth/jwt/login')

authentication_backend = AuthenticationBackend(
    name='jwt',
    transport=bearer_transport,
    get_strategy=get_jwt_strategy
)

fastapi_users = FastAPIUsers[User, int](
    get_user_manager,
    [authentication_backend]
)

authentication_router = fastapi_users.get_auth_router(authentication_backend)

registration_router = fastapi_users.get_register_router(UserRead, UserCreate)