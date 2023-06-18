from passlib.context import CryptContext
import os
from datetime import datetime, timedelta
from jose import jwt
from dotenv import load_dotenv

load_dotenv()

password_context = CryptContext(schemes=['bcrypt'], deprecated=['auto'])

ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv('ACCESS_TOKEN_EXPIRE_MINUTES'))
REFRESH_TOKEN_EXPIRE_MINUTES = int(os.getenv('REFRESH_TOKEN_EXPIRE_MINUTES'))
ALGORITHM = os.getenv('JWT_ALGORITHM')
JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY')
JWT_REFRESH_SECRET_KEY = os.getenv('JWT_REFRESH_SECRET_KEY')


def get_hashed_password(password: str) -> str:
    return password_context.hash(password)


def verify_password(password: str, hashed_password: str) -> bool:
    return password_context.verify(password, hashed_password)


def create_access_token(data: dict, expires_delta:timedelta | None = None) -> str:
    if expires_delta:
        expires_datetime = datetime.utcnow() + expires_delta
    else:
        expires_datetime = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)

    data_to_encode = {'expires': expires_datetime.isoformat(), 'data': data}
    encoded_jwt = jwt.encode(data_to_encode, JWT_SECRET_KEY, ALGORITHM)
    return encoded_jwt
