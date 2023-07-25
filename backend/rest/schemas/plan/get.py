from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional


class PlanToLandmarkOut(BaseModel):
    landmark_id: str
    visit_date: Optional[datetime] = None


class PlanGetByIdIn(BaseModel):
    plan_id: str


class PlanGetByIdOut(BaseModel):
    plan_id: str | None
    name: str | None
    description: str | None
    locations: List[PlanToLandmarkOut] | None
