from fastapi_users.authentication import CookieTransport, AuthenticationBackend
from fastapi_users import FastAPIUsers
import uuid

from postgresql_microservice.dependencies import get_user_manager
from postgresql_microservice.models import User
from postgresql_microservice.schemas import  UserRead, UserCreate
from postgresql_microservice.config import COOKIE_MAX_AGE
from postgresql_microservice.dependencies import get_jwt_strategy

cookie_transport = CookieTransport(cookie_max_age=COOKIE_MAX_AGE)

authentication_backend = AuthenticationBackend(
    name='jwt',
    transport=cookie_transport,
    get_strategy= get_jwt_strategy
)

fastapi_users = FastAPIUsers[User, uuid.UUID](
    get_user_manager,
    [authentication_backend]
)

authentication_router = fastapi_users.get_auth_router(authentication_backend)

registration_router = fastapi_users.get_register_router(UserRead, UserCreate)