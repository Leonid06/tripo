from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from postgresql_microservice.config import POSTGRES_USERNAME, POSTGRES_PASSWORD, POSTGRES_HOST, \
    POSTGRES_PORT, POSTGRES_DATABASE_NAME


DATABASE_URL = f'postgresql://{POSTGRES_USERNAME}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DATABASE_NAME}'
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind= engine)
Base = declarative_base()