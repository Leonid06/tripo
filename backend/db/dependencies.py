import uuid
from fastapi import Depends, Request
from fastapi_users.db import SQLAlchemyUserDatabase
from fastapi_users.authentication import JWTStrategy
from fastapi_users import BaseUserManager, IntegerIDMixin
from sqlalchemy.pool import NullPool
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from typing import Optional, AsyncGenerator

from db.models import User
from db.config import JWT_SECRET_KEY, ACCESS_TOKEN_EXPIRE_SECONDS
from db.config import POSTGRES_USERNAME, POSTGRES_PASSWORD, POSTGRES_HOST, \
    POSTGRES_PORT, POSTGRES_DATABASE_NAME, POSTGRES_TEST_HOST, POSTGRES_TEST_PORT, \
    POSTGRES_TEST_DATABASE_NAME

MAIN_DATABASE_URL = f'postgresql+asyncpg://{POSTGRES_USERNAME}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DATABASE_NAME}'
TEST_DATABASE_URL = f'postgresql+asyncpg://' \
                    f'{POSTGRES_USERNAME}:{POSTGRES_PASSWORD}@{POSTGRES_TEST_HOST}:{POSTGRES_TEST_PORT}/{POSTGRES_TEST_DATABASE_NAME}'

main_engine = create_async_engine(MAIN_DATABASE_URL)
main_async_session_maker = async_sessionmaker(main_engine, expire_on_commit=False)

test_engine = create_async_engine(TEST_DATABASE_URL, poolclass=NullPool)
test_async_session_maker = async_sessionmaker(test_engine, expire_on_commit=False)


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


async def get_test_async_session() -> AsyncGenerator[AsyncSession, None]:
    async with test_async_session_maker() as session:
        yield session


async def get_main_async_session() -> AsyncGenerator[AsyncSession, None]:
    async with main_async_session_maker() as session:
        yield session


async def get_test_user_db(session: AsyncSession = Depends(get_test_async_session)):
    yield SQLAlchemyUserDatabase(session, User)


async def get_main_user_db(session: AsyncSession = Depends(get_main_async_session)):
    yield SQLAlchemyUserDatabase(session, User)


def get_jwt_strategy() -> JWTStrategy:
    return JWTStrategy(secret=JWT_SECRET_KEY, lifetime_seconds=ACCESS_TOKEN_EXPIRE_SECONDS)


async def get_test_user_manager(user_db=Depends(get_test_user_db)):
    yield UserManager(user_db)


async def get_main_user_manager(user_db=Depends(get_main_user_db)):
    yield UserManager(user_db)
