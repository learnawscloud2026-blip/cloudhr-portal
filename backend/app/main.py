from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from sqlalchemy import text

from app.database.connection import engine
from app.database.session import Base

from app.models.employee import Employee
from app.models.department import Department

from app.api.employee import router as employee_router
from app.api.department import router as department_router


app = FastAPI(
    title="CloudHR Portal API",
    version="1.0.0",
    description="Employee Management API built using FastAPI and AWS",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://cloudhr-dev-alb-5812763.us-east-1.elb.amazonaws.com",
        "http://localhost:5173",
        "http://localhost:3000",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def root():
    return {
        "message": "Welcome to CloudHR Portal"
    }


@app.get("/health")
def health():
    return {
        "status": "UP"
    }


with engine.connect() as conn:
    result = conn.execute(text("SELECT 1"))
    print("Database Connection Successful:", result.scalar())


Base.metadata.create_all(bind=engine)


app.include_router(employee_router)
app.include_router(department_router)