import logging

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from postgresql_microservice.schemas.plan.create import PlanManualCreateIn, PlanManualCreateOut
from postgresql_microservice.crud.plan.create import save_plan_created_manually
from postgresql_microservice.dependencies import get_async_session
from postgresql_microservice.exception import DatabaseDataError, DatabaseTimeoutError, \
    DatabaseDisconnectionError, DatabaseResourceInvalidatedError

logger = logging.getLogger(__name__)

plan_create_router = APIRouter(
    prefix  = '/plan/create',
    tags = ['plan/create']
)


@plan_create_router.post('/manual')
async def create_plan_manually(payload : PlanManualCreateIn, db : AsyncSession = Depends(get_async_session)) -> PlanManualCreateOut:
    try:
        await save_plan_created_manually(payload=payload, db = db)
    except DatabaseDataError as error:
        logger.exception(error)
        raise HTTPException(status_code=400, detail= 'Invalid request format') from error
    except DatabaseTimeoutError as error:
        logger.exception(error)
        raise HTTPException(status_code=504) from error
    except (DatabaseDisconnectionError, DatabaseResourceInvalidatedError) as error:
        logger.exception(error)
        raise HTTPException(status_code=502) from error

    return PlanManualCreateOut(message='Plan was successfully created')


