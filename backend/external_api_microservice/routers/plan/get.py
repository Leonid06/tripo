from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from postgresql_microservice.schemas.plan.get import PlanGetByIdIn, PlanGetByIdOut
from postgresql_microservice.crud.plan.get import select_plan_by_id
from postgresql_microservice.dependencies import get_async_session
from postgresql_microservice.exception import DatabaseDataError, DatabaseTimeoutError, \
    DatabaseDisconnectionError, DatabaseResourceInvalidatedError, DatabaseNoResultFoundError

plan_get_router = APIRouter(
    prefix='/plan/get',
    tags=['plan/get']
)


@plan_get_router.post('/by-id')
async def get_plan_by_id(payload: PlanGetByIdIn, db: AsyncSession = Depends(get_async_session)) -> PlanGetByIdOut:
    try:
        plan = await select_plan_by_id(payload=payload, db=db)
    except DatabaseDataError as error:
        raise HTTPException(status_code=400, detail='Invalid request format') from error
    except DatabaseTimeoutError as error:
        raise HTTPException(status_code=504) from error
    except (DatabaseDisconnectionError, DatabaseResourceInvalidatedError) as error:
        raise HTTPException(status_code=502) from error
    except DatabaseNoResultFoundError:
        plan = PlanGetByIdOut()

    return plan
