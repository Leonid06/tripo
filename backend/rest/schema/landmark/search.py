from typing import List

from pydantic import BaseModel


class SearchLandmarkByRadiusIn(BaseModel):
    latitude: str
    longitude: str
    radius: str


class SearchLandmarkOutUnit(BaseModel):
    id: str
    name: str


class SearchLandmarkOut(BaseModel):
    landmark: List[SearchLandmarkOutUnit]
