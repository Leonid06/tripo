from .database import Base
import os
from sqlalchemy import Boolean, Column, ForeignKey, Integer, String, Text, DateTime
from sqlalchemy.orm import relationship



LANDMARKS_TABLE_NAME = os.getenv('LANDMARKS_TABLE_NAME')
PLANS_TABLE_NAME = os.getenv('PLANS_TABLE_NAME')
USERS_TABLE_NAME = os.getenv('USERS_TABLE_NAME')
PLANS_TO_LANDMARKS_TABLE_NAME = os.getenv('PLANS_TO_LANDMARKS_TABLE_NAME')
PLANS_TO_USERS_TABLE_NAME = os.getenv('PLANS_TO_USERS_TABLE_NAME')


class Landmark(Base):
    __tablename__ = LANDMARKS_TABLE_NAME
    id = Column(Integer, primary_key = True, index = True)
    name = Column(String, index = True)
    description = Column(Text, index = True)
    type = Column(String, index = True)


class Plan(Base):
    __tablename__ = PLANS_TABLE_NAME
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    description = Column(Text, index=True)
    completed = Column(Boolean, index = True)

class User(Base):
    __tablename__ = USERS_TABLE_NAME
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique= True, index = True)
    hashed_password = Column(String)
    is_active = Column(Boolean, default= True)

class PlanToLandmark(Base):
    __tablename__ = PLANS_TO_LANDMARKS_TABLE_NAME
    id = Column(Integer, primary_key=True,index=True)
    plan_id = Column(Integer, ForeignKey(f'{PLANS_TABLE_NAME}.id'))
    landmark_id = Column(Integer, ForeignKey(f'{LANDMARKS_TABLE_NAME}.id'))
    visited = Column(Boolean, default=False)
    visit_date = Column(DateTime)

class PlanToUser(Base):
    __tablename__ = PLANS_TO_USERS_TABLE_NAME
    id = Column(Integer, primary_key=True, index=True)
    plan_id = Column(Integer, ForeignKey(f'{PLANS_TABLE_NAME}.id'))
    user_id = Column(Integer, ForeignKey(f'{USERS_TABLE_NAME}.id'))


