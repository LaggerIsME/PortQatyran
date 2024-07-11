from fastapi import FastAPI, APIRouter
from fastapi.middleware.cors import CORSMiddleware

# Changed OpenAPI docs path to /api/
app = FastAPI(docs_url="/api/docs", redoc_url="/api/redoc", openapi_url="/api/openapi.json")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Created api router
api_router = APIRouter(prefix="/api")


# Root
@api_router.get("/")
async def root():
    return {"message": "Hello World"}


# Logs
@api_router.get("/logs")
async def say_hello():
    return {"message": f"Hello man"}

# Added api router to the app
app.include_router(api_router)
