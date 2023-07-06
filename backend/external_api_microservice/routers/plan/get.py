from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from postgresql_microservice.schemas.plan.get import PlanGetByIdIn, PlanGetByIdOut
from postgresql_microservice.crud.plan.get import select_plan_by_id
from postgresql_microservice.dependencies import get_async_session

plan_get_router = APIRouter(
    prefix='/plan/get',
    tags=['plan/get']
)


@plan_get_router.post('/by-id')
async def get_plan_by_id(payload: PlanGetByIdIn, db: AsyncSession = Depends(get_async_session)) -> PlanGetByIdOut:
    return await select_plan_by_id(payload=payload, db=db)
