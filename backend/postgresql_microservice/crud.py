from sqlalchemy.orm import Session
from dependencies import get_db
from fastapi import Depends
from utils import get_hashed_password
import schemas
from models import User


def get_user_by_email(email: str, db: Session = Depends(get_db)):
    return db.query(User).filter(User.email == email).first()


def create_user(data: schemas.UserIn, db: Session = Depends(get_db)):
    hashed_password = get_hashed_password(data.password)
    user = User(email=data.email, hashed_password=hashed_password)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user

