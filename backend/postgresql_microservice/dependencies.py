import os

from database import SessionLocal
from typing import Annotated
from fastapi import Depends
from fastapi.security import OAuth2PasswordBearer
from dotenv import load_dotenv
from models import User
import jwt

# load_dotenv()
# oauth2_scheme = OAuth2PasswordBearer(tokenUrl= os.getenv('BEARER_TOKEN_URL'))

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

#
# def decode_bearer_token(encoded_token: str):
#     secret_key = os.getenv('JWT_SECRET_KEY')
#     encoding_algorithm = os.getenv('JWT_ALGORITHM')
#     return jwt.decode(encoded_token, secret_key, algorithms= [encoding_algorithm])
#
# def get_current_user(token: Annotated[str, Depends(oauth2_scheme)]):
#     return User()