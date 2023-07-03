from fastapi_users.db import SQLAlchemyBaseUserTable
from sqlalchemy import Boolean, Column, ForeignKey, Integer, String, Text, DateTime

from postgresql_microservice.database import Base
from postgresql_microservice.config import LANDMARKS_TABLE_NAME, PLANS_TABLE_NAME, USERS_TABLE_NAME, \
    PLANS_TO_LANDMARKS_TABLE_NAME, PLANS_TO_USERS_TABLE_NAME


class User(SQLAlchemyBaseUserTable[int], Base):
    id = Column("id", Integer, primary_key=True)


class Landmark(Base):
    __tablename__ = LANDMARKS_TABLE_NAME
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    description = Column(Text, index=True)
    type = Column(String, index=True)


class Plan(Base):
    __tablename__ = PLANS_TABLE_NAME
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    description = Column(Text, index=True)
    completed = Column(Boolean, index=True, default= False)


class PlanToLandmark(Base):
    __tablename__ = PLANS_TO_LANDMARKS_TABLE_NAME
    id = Column(Integer, primary_key=True, index=True)
    plan_id = Column(Integer, ForeignKey(f'{PLANS_TABLE_NAME}.id'))
    landmark_id = Column(Integer, ForeignKey(f'{LANDMARKS_TABLE_NAME}.id'))
    visited = Column(Boolean, default=False)
    visit_date = Column(DateTime)


class PlanToUser(Base):
    __tablename__ = PLANS_TO_USERS_TABLE_NAME
    id = Column(Integer, primary_key=True, index=True)
    plan_id = Column(Integer, ForeignKey(f'{PLANS_TABLE_NAME}.id'))
    user_id = Column(Integer, ForeignKey(f'{USERS_TABLE_NAME}.id'))
