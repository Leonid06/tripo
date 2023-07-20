from pydantic import BaseModel
from typing import List


class GetCachedLandmarkInUnit(BaseModel):
    id: str


class GetCachedLandmarkIn(BaseModel):
    landmark: List[GetCachedLandmarkInUnit]


class GetCachedLandmarkOutUnit(BaseModel):
    id: str
    name: str


class GetCachedLandmarkOut(BaseModel):
    landmark: List[GetCachedLandmarkOutUnit]
