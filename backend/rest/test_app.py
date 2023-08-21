from fastapi import FastAPI
from db.auth.authentication_setup import authentication_router, registration_router
from db.dependencies import get_main_async_session, get_test_async_session
from rest.router.plan.create import plan_create_router
from rest.router.plan.get import plan_get_router
from rest.router.plan.edit import plan_edit_router
from rest.router.landmark.get import landmark_get_router
from rest.router.landmark.search import landmark_search_router

app = FastAPI()

app.dependency_overrides[get_main_async_session] = get_test_async_session

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
app.include_router(plan_edit_router)
app.include_router(plan_delete_router)
app.include_router(landmark_get_router)
app.include_router(landmark_search_router)
