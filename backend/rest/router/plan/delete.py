from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from rest.schema.plan.delete import PlanDeleteByIdIn, PlanDeleteByIdOut
from db.crud.plan.delete import delete_plan_by_id
from db.dependencies import get_main_async_session
from db.exception import DatabaseDataError, DatabaseTimeoutError, \
    DatabaseDisconnectionError, DatabaseResourceInvalidatedError, DatabaseNoResultFoundError, \
    DatabaseDriverError

plan_delete_router = APIRouter(
    prefix='/plan/delete',
    tags=['plan/delete']
)


@plan_delete_router.delete('by-id')
async def delete_plan_by_id_endpoint(payload: PlanDeleteByIdIn,
                                     db: AsyncSession = Depends(get_main_async_session)) -> PlanDeleteByIdOut:
    try:
        plan = await delete_plan_by_id(payload=payload, db=db)
    except DatabaseDataError as error:
        raise HTTPException(status_code=400, detail='Invalid request format') from error
    except DatabaseTimeoutError as error:
        raise HTTPException(status_code=504) from error
    except (DatabaseDisconnectionError, DatabaseResourceInvalidatedError, DatabaseDriverError) as error:
        raise HTTPException(status_code=502) from error
    except DatabaseNoResultFoundError:
        plan = PlanDeleteByIdOut()

    return plan
