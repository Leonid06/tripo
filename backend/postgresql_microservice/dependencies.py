import os

from sqlalchemy.orm import Session
from postgresql_microservice.database import SessionLocal
from typing import Annotated
from fastapi import Depends, status, HTTPException
from fastapi.security import OAuth2PasswordBearer
from dotenv import load_dotenv
from jose import jwt, JWTError
from postgresql_microservice.models import User

load_dotenv()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl=os.getenv('BEARER_TOKEN_URL'))

ALGORITHM = os.getenv('JWT_ALGORITHM')
JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY')


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_current_user(token: Annotated[str, Depends(oauth2_scheme)], db : Session = Depends(SessionLocal)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        payload = jwt.decode(token, JWT_SECRET_KEY, algorithms=[ALGORITHM])
        email = payload.get('email')
        if email is None:
            raise credentials_exception

    except JWTError:
        raise credentials_exception

    user = db.query(User).filter(User.email == email)

    if user is None:
        raise credentials_exception

    return user

#
# def decode_bearer_token(encoded_token: str):
#     secret_key = os.getenv('JWT_SECRET_KEY')
#     encoding_algorithm = os.getenv('JWT_ALGORITHM')
#     return jwt.decode(encoded_token, secret_key, algorithms= [encoding_algorithm])
#
# def get_current_user(token: Annotated[str, Depends(oauth2_scheme)]):
#     return User()
