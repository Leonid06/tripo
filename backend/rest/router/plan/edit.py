

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from rest.schema.plan.edit import PlanEditByIdIn, PlanEditByIdOut
from db.crud.plan.edit import put_plan_by_id
from db.dependencies import get_main_async_session
from db.exception import DatabaseDataError, DatabaseTimeoutError, \
    DatabaseDisconnectionError, DatabaseResourceInvalidatedError, DatabaseDriverError

plan_edit_router = APIRouter(
    prefix='/plan/edit',
    tags=['plan/edit']
)


@plan_edit_router.put('/by-id')
async def edit_plan_by_id_endpoint(payload: PlanEditByIdIn, db: AsyncSession = Depends(get_main_async_session)) -> PlanEditByIdOut:
    try:
        outward_schema = await put_plan_by_id(payload=payload, db=db)
    except DatabaseDataError as error:
        raise HTTPException(status_code=400, detail='Invalid request format') from error
    except DatabaseTimeoutError as error:
        raise HTTPException(status_code=504) from error
    except (DatabaseDisconnectionError, DatabaseResourceInvalidatedError, DatabaseDriverError) as error:
        raise HTTPException(status_code=502) from error

    return outward_schema

