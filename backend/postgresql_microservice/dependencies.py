import uuid
from fastapi import Depends, Request
from fastapi_users.db import SQLAlchemyUserDatabase
from fastapi_users.authentication import JWTStrategy
from fastapi_users import BaseUserManager, IntegerIDMixin
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from typing import Optional, AsyncGenerator

from postgresql_microservice.models import User
from postgresql_microservice.config import JWT_SECRET_KEY, ACCESS_TOKEN_EXPIRE_SECONDS
from postgresql_microservice.config import POSTGRES_USERNAME, POSTGRES_PASSWORD, POSTGRES_HOST, \
    POSTGRES_PORT, POSTGRES_DATABASE_NAME

DATABASE_URL = f'postgresql+asyncpg://{POSTGRES_USERNAME}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DATABASE_NAME}'

engine = create_async_engine(DATABASE_URL)
async_session_maker = async_sessionmaker(engine, expire_on_commit= False)


class UserManager(IntegerIDMixin, BaseUserManager[User, int]):
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
