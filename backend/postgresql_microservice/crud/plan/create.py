from postgresql_microservice.dependencies import get_async_session
from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession
from postgresql_microservice.schemas.plan.create import PlanManualCreateIn
from postgresql_microservice.models import Plan, PlanToLandmark


async def save_plan_created_manually(payload: PlanManualCreateIn, db: AsyncSession):
    plan_to_landmark_entities_data = payload.plan_to_landmark

    plan = Plan(name=payload.name, description=payload.description)

    async with db.begin():
        db.add(plan)

        for plan_to_landmark_entity_data in plan_to_landmark_entities_data:
            plan_to_landmark = PlanToLandmark(
                plan_id=plan.id,
                landmark_id=plan_to_landmark_entity_data.landmark_id,
                visit_date=plan_to_landmark_entity_data.visit_date
            )
            db.add(plan_to_landmark)

        await db.commit()
