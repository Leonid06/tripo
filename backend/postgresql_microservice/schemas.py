from pydantic import BaseModel

class UserBase(BaseModel):
    email : str

class UserIn(UserBase):
    password : str

class UserOut(UserBase):
    id : int
    is_active : bool

class TokenSchema(BaseModel):
    access_token : str
    refresh_token : str