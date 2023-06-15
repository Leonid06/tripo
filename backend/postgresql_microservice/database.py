from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
import os

load_dotenv()

POSTGRES_USERNAME = os.getenv('POSTGRESQL_USERNAME')
POSTGRES_PASSWORD = os.getenv('POSTGRESQL_PASSWORD')
POSTGRES_HOST = os.getenv('POSTGRESQL_HOST')
POSTGRES_PORT = os.getenv('POSTGRESQL_PORT')
POSTGRES_DATABASE_NAME = os.getenv('POSTGRESQL_DATABASE_NAME')
DATABASE_URL = f'postgresql://{POSTGRES_USERNAME}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DATABASE_NAME}'


print(DATABASE_URL)

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind= engine)
Base = declarative_base()