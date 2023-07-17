from pydantic import BaseModel
from typing import List


class GetLandmarkInUnit(BaseModel):
    id: str


class GetLandmarkIn(BaseModel):
    landmark: List[GetLandmarkInUnit]


class GetLandmarkOutUnit(BaseModel):
    id: str
    name: str


class GetLandmarkOut(BaseModel):
    landmark: List[GetLandmarkOutUnit]
