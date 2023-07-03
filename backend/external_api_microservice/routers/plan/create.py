from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from postgresql_microservice.schemas.plan.create import PlanManualCreateIn, PlanManualCreateOut
from postgresql_microservice.crud.plan.create import save_plan_created_manually
from postgresql_microservice.dependencies import get_async_session
plan_create_router = APIRouter(
    prefix  = '/plan/create',
    tags = ['plan/create']
)


@plan_create_router.post('/manual')
async def create_plan_manually(payload : PlanManualCreateIn, db : AsyncSession = Depends(get_async_session)) -> PlanManualCreateOut:
    await save_plan_created_manually(payload=payload, db = db)

    return PlanManualCreateOut(message='Plan was successfully created')


