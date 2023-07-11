from pydantic import BaseModel


class GetLandmarkIn(BaseModel):
    id : str

class GetLandmarkOut(BaseModel):
    name : str

