import uuid
from fastapi import Depends, Request
from fastapi_users.db import SQLAlchemyUserDatabase
from fastapi_users.authentication import JWTStrategy
from fastapi_users import BaseUserManager, UUIDIDMixin
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from typing import Optional, AsyncGenerator

from microservices.postgresql_microservice.models import User
from microservices.postgresql_microservice.config import JWT_SECRET_KEY, ACCESS_TOKEN_EXPIRE_SECONDS
from microservices.postgresql_microservice.config import POSTGRES_USERNAME, POSTGRES_PASSWORD, POSTGRES_HOST, \
    POSTGRES_PORT, POSTGRES_DATABASE_NAME

DATABASE_URL = f'postgresql+asyncpg://{POSTGRES_USERNAME}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DATABASE_NAME}'

engine = create_async_engine(DATABASE_URL)
async_session_maker = async_sessionmaker(engine)


class UserManager(UUIDIDMixin, BaseUserManager[User, uuid.UUID]):
    reset_password_token_secret = JWT_SECRET_KEY
    verification_token_secret = JWT_SECRET_KEY

    async def on_after_register(self, user: User, request: Optional[Request] = None):
        print(f"User {user.id} has registered.")

    async def on_after_forgot_password(
            self, user: User, token: str, request: Optional[Request] = None
    ):
        print(f"User {user.id} has forgot their password. Reset token: {token}")

    async def on_after_request_verify(
            self, user: User, token: str, request: Optional[Request] = None
    ):
        print(f"Verification requested for user {user.id}. Verification token: {token}")


async def get_async_session() -> AsyncGenerator[AsyncSession, None]:
    async with async_session_maker() as session:
        yield session


async def get_user_db(session: AsyncSession = Depends(get_async_session)):
    yield SQLAlchemyUserDatabase(session, User)


def get_jwt_strategy() -> JWTStrategy:
    return JWTStrategy(secret=JWT_SECRET_KEY, lifetime_seconds=ACCESS_TOKEN_EXPIRE_SECONDS)


async def get_user_manager(user_db=Depends(get_user_db)):
    yield UserManager(user_db)

#
# def get_current_user(token: Annotated[str, Depends(oauth2_scheme)], db: Session = Depends(get_async_session)):
#     credentials_exception = HTTPException(
#         status_code=status.HTTP_401_UNAUTHORIZED,
#         detail="Could not validate credentials",
#         headers={"WWW-Authenticate": "Bearer"},
#     )
#
#     try:
#         payload = jwt.decode(token, JWT_SECRET_KEY, algorithms=[ALGORITHM])
#         email = payload.get('email')
#         if email is None:
#             raise credentials_exception
#
#     except JWTError:
#         raise credentials_exception
#
#     user = db.query(User).filter(User.email == email)
#
#     if user is None:
#         raise credentials_exception
#
#     return user

#
# def decode_bearer_token(encoded_token: str):
#     secret_key = os.getenv('JWT_SECRET_KEY')
#     encoding_algorithm = os.getenv('JWT_ALGORITHM')
#     return jwt.decode(encoded_token, secret_key, algorithms= [encoding_algorithm])
#
# def get_current_user(token: Annotated[str, Depends(oauth2_scheme)]):
#     return User()
