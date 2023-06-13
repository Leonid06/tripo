from typing import Union
from fastapi import FastAPI
import os
from postgresql_microservice import crud, models
from postgresql_microservice.database import SessionLocal, engine
import uvicorn

app = FastAPI()

def main():
    models.Base.metadata.create_all(bind=engine)

    @app.get('/')
    def read_root():
        return {'Hello' : 'World'}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)




