from typing import  Dict
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import update
from sqlalchemy.exc import DisconnectionError, TimeoutError, ResourceClosedError, \
    DBAPIError, NoResultFound

from rest.schema.plan.edit import PlanEditByIdIn, PlanEditByIdOut
from db.models import Plan

from db.exception import DatabaseDataError, DatabaseDisconnectionError, \
    DatabaseTimeoutError, DatabaseResourceInvalidatedError, DatabaseNoResultFoundError, \
    DatabaseDriverError


async def edit_plan_by_id(payload: PlanEditByIdIn, db: AsyncSession) -> PlanEditByIdOut:
    try:
        async with db.begin():

            await db.execute(
                update(Plan).where(Plan.public_id == payload.id)
                .values(name=payload.name,
                        description = payload.description,
                        completed = payload.completed)
            )
            await db.commit()
        return PlanEditByIdOut()
    except (TypeError, AttributeError) as error:
        raise DatabaseDataError from error
    except NoResultFound as error:
        raise DatabaseNoResultFoundError from error
    except DisconnectionError as error:
        raise DatabaseDisconnectionError from error
    except TimeoutError as error:
        raise DatabaseTimeoutError from error
    except ResourceClosedError as error:
        raise DatabaseResourceInvalidatedError from error
    except DBAPIError as error:
        raise DatabaseDriverError from error

