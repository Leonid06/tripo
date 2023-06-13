from typing import Union
from fastapi import FastAPI
import os
from postgresql_microservice import crud, models
from postgresql_microservice.database import SessionLocal, engine

app = FastAPI()


def main():
    models.Base.metadata.create_all(bind=engine)

    @app.get('/')
    def read_root():
        return {'Hello' : 'World'}




