from sqlalchemy.orm import Session
from postgresql_microservice.utils import get_hashed_password, create_access_token
import postgresql_microservice.schemas
from postgresql_microservice.models import User


def get_user_by_email(email: str, db: Session):
    return db.query(User).filter(User.email == email).first()


def create_user(data: postgresql_microservice.schemas.UserIn, db: Session):
    hashed_password = get_hashed_password(data.password)
    user = User(email=data.email, hashed_password=hashed_password)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user


def generate_access_token_for_user(user: User) -> str:
    payload_data = {
        'email': user.email,
        'hashed_password': user.hashed_password
    }
    return create_access_token(data=payload_data)


def get_user_by_inward_schema(data: postgresql_microservice.schemas.UserIn, db: Session):
    hashed_password = get_hashed_password(data.password)
    user = db.query(User).filter(User.email == data.email and User.hashed_password == hashed_password).first()
    return user
