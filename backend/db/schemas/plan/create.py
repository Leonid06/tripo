from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional


class PlanToLandmarkIn(BaseModel):
    landmark_id: int
    visit_date: Optional[datetime] = None


class PlanManualCreateIn(BaseModel):
    name: str
    description: str
    plan_to_landmark: List[PlanToLandmarkIn]


class PlanManualCreateOut(BaseModel):
    id : str
