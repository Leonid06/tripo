from pydantic import BaseModel


class PlanDeleteByIdIn(BaseModel):
    id: str


class PlanDeleteByIdOut(BaseModel):
    pass
