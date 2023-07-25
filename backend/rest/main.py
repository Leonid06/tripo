from fastapi import FastAPI
from db.auth.authentication_setup import authentication_router, registration_router
from rest.routers.plan.create import plan_create_router
from rest.routers.plan.get import plan_get_router
from rest.routers.landmark.get import landmark_get_router
from rest.routers.landmark.search import landmark_search_router

app = FastAPI()

app.include_router(
    router=authentication_router,
    prefix="/auth",
    tags=["Auth"],
)

app.include_router(
    router=registration_router,
    prefix="/auth",
    tags=["Auth"],
)

app.include_router(plan_create_router)
app.include_router(plan_get_router)
app.include_router(landmark_get_router)
app.include_router(landmark_search_router)

