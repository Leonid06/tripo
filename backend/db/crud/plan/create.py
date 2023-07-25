from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import DisconnectionError, TimeoutError, ResourceClosedError, \
    DBAPIError, NoResultFound
from rest.schemas.plan.create import PlanManualCreateIn, PlanManualCreateOut
from db.models import Plan, Landmark, PlanToLandmark
from db.exception import DatabaseDataError, DatabaseDisconnectionError, \
    DatabaseTimeoutError, DatabaseResourceInvalidatedError, DatabaseDriverError,\
    DatabaseNoResultFoundError
from db.crud.util import generate_random_uuid_string


async def save_plan_created_manually(payload: PlanManualCreateIn, db: AsyncSession):
    try:
        plan_to_landmark_entities_data = payload.plan_to_landmark
        plan = Plan(name=payload.name,
                    public_id=generate_random_uuid_string(),
                    description=payload.description)
    except TypeError as error:
        raise DatabaseDataError from error

    try:
        async with db.begin():
            db.add(plan)

            for plan_to_landmark_entity_data in plan_to_landmark_entities_data:
                landmark = await db.get(Landmark, {'public_id': plan_to_landmark_entity_data.landmark_id})
                plan_to_landmark = PlanToLandmark(
                    plan_id=plan.id,
                    landmark_id=landmark.id,
                    visit_date=plan_to_landmark_entity_data.visit_date
                )
                db.add(plan_to_landmark)

            await db.commit()

    except (TypeError, AttributeError) as error:
        raise DatabaseDataError from error
    except DisconnectionError as error:
        raise DatabaseDisconnectionError from error
    except TimeoutError as error:
        raise DatabaseTimeoutError from error
    except ResourceClosedError as error:
        raise DatabaseResourceInvalidatedError from error
    except DBAPIError as error:
        raise DatabaseDriverError from error
    except NoResultFound as error:
        raise DatabaseNoResultFoundError from error

    return PlanManualCreateOut(id=plan.public_id)

