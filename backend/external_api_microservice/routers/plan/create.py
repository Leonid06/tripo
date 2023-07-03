from fastapi import APIRouter
from postgresql_microservice.schemas.plan.create import PlanManualCreateIn, PlanManualCreateOut
from postgresql_microservice.crud.plan.create import save_plan_created_manually
plan_create_router = APIRouter(
    prefix  = '/plan/create',
    tags = ['plan', 'create']
)


@plan_create_router.post('/manual')
async def create_plan_manually(payload : PlanManualCreateIn) -> PlanManualCreateOut:
    save_plan_created_manually(payload=payload)

    return PlanManualCreateOut(message = 'Plan was successfully created')


