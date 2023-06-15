
from fastapi import FastAPI
from postgresql_microservice import crud, models
from postgresql_microservice.database import SessionLocal, engine



models.Base.metadata.create_all(bind=engine)

app = FastAPI()

@app.get('/')
def read_root():
    return {'Hello' : 'World'}





