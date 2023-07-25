from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.exc import DisconnectionError, TimeoutError, ResourceClosedError, \
    NoResultFound

from rest.schema.plan.get import PlanGetByIdIn, PlanGetByIdOut, PlanToLandmarkOut
from db.models import Plan, PlanToLandmark
from db.exception import DatabaseDataError, DatabaseDisconnectionError, \
    DatabaseTimeoutError, DatabaseResourceInvalidatedError, DatabaseNoResultFoundError


async def select_plan_by_id(payload: PlanGetByIdIn, db: AsyncSession) -> PlanGetByIdOut:
    try:
        async with db.begin():
            plan_query_result = await db.execute(
                select(Plan).where(Plan.public_id == payload.plan_id)
            )
            plan = plan_query_result.scalar()
            plan_to_landmark_data_query_result = await db.execute(
                select(PlanToLandmark).where(PlanToLandmark.plan_id == plan.id))
            await db.commit()
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

    plan_to_landmark_data = plan_to_landmark_data_query_result.scalars()
    locations = []

    for plan_to_landmark in plan_to_landmark_data:
        plan_to_landmark_response_object = PlanToLandmarkOut(
            landmark_id= str(plan_to_landmark.landmark_id),
            visit_date=plan_to_landmark.visit_date)
        locations.append(plan_to_landmark_response_object)

    response_object = PlanGetByIdOut(
        plan_id= str(plan.id),
        name=plan.name,
        description=plan.description,
        locations=locations
    )

    return response_object
