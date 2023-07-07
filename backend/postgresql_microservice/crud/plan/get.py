from sqlalchemy.ext.asyncio import AsyncSession
from postgresql_microservice.schemas.plan.get import PlanGetByIdIn, PlanGetByIdOut, PlanToLandmarkOut
from postgresql_microservice.models import Plan, PlanToLandmark
from sqlalchemy import select


async def select_plan_by_id(payload: PlanGetByIdIn, db: AsyncSession) -> PlanGetByIdOut:
    plan = await db.get(Plan, {'id': payload.plan_id})
    plan_to_landmark_data_query_result = await db.execute(select(PlanToLandmark).where(PlanToLandmark.plan_id == plan.id))
    plan_to_landmark_data = plan_to_landmark_data_query_result.scalars()
    locations = []

    for plan_to_landmark in plan_to_landmark_data:
        print(plan_to_landmark)
        plan_to_landmark_response_object = PlanToLandmarkOut(
            landmark_id=plan_to_landmark.landmark_id,
            visit_date=plan_to_landmark.visit_date)
        locations.append(plan_to_landmark_response_object)

    response_object = PlanGetByIdOut(
        plan_id=plan.id,
        name=plan.name,
        description=plan.description,
        locations=locations
    )

    return response_object
