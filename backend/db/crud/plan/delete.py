from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import delete
from sqlalchemy.exc import DisconnectionError, TimeoutError, ResourceClosedError, \
    NoResultFound, DBAPIError

from rest.schema.plan.delete import PlanDeleteByIdIn, PlanDeleteByIdOut
from db.models import Plan
from db.exception import DatabaseDataError, DatabaseDisconnectionError, \
    DatabaseTimeoutError, DatabaseResourceInvalidatedError, DatabaseNoResultFoundError, \
    DatabaseDriverError


async def delete_plan_by_id(payload: PlanDeleteByIdIn, db: AsyncSession) -> PlanDeleteByIdOut:
    try:
        async with db.begin():
            await db.execute(
                delete(Plan).where(Plan.public_id == payload.id)
            )
            await db.commit()

            return PlanDeleteByIdOut()
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

