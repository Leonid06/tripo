from pydantic import BaseModel


class GetLandmarkIn(BaseModel):
    id : str

class GetLandmarkOut(BaseModel):
    id : str
    name : str

