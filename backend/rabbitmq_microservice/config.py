from dotenv import load_dotenv
import os

load_dotenv()

RABBITMQ_HOST = os.getenv('RABBITMQ_HOST')
