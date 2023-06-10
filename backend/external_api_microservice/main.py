from typing import Union
from fastapi import FastAPI
import os
from pydantic import BaseModel
import sqlalchemy
from dotenv import load_dotenv
import databases

POSTGRES_USERNAME = os.getenv('POSTGRESQL_USERNAME')
POSTGRES_PASSWORD = os.getenv('POSTGRESQL_PASSWORD')
POSTGRES_HOST = os.getenv('POSTGRESQL_HOST')
POSTGRES_PORT = os.getenv('POSTGRESQL_PORT')
POSTGRES_DATABASE_NAME = os.getenv('POSTGRESQL_PORT')
DATABASE_URL = f'postgresql://{POSTGRES_USERNAME}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DATABASE_NAME}'

def main():

    app = FastAPI()

    @app.get('/')
    def read_root():
        return {'Hello' : 'World'}




