from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional


class PlanEditByIdIn(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    completed: Optional[bool] = None


class PlanEditByIdOut(BaseModel):
    pass
