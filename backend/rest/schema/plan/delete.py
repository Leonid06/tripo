from pydantic import BaseModel


class PlanDeleteIn(BaseModel):
    id: str


class PlanDeleteOut(BaseModel):
    pass
