from fastapi import APIRouter
from postgresql_microservice.schemas.plan.create import PlanManualCreateIn, PlanManualCreateOut

plan_create_router = APIRouter(
    prefix  = '/plan/create',
    tags = ['plan', 'create']
)


@plan_create_router.post('/manual')
async def create_plan_manually(payload : PlanManualCreateIn) -> PlanManualCreateOut:
    pass


