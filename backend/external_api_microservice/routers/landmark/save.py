from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from postgresql_microservice.schemas.plan.create import PlanManualCreateIn, PlanManualCreateOut
from postgresql_microservice.crud.plan.create import save_plan_created_manually
from postgresql_microservice.dependencies import get_async_session
plan_create_router = APIRouter(
    prefix  = '/plan/create',
    tags = ['plan/create']
)