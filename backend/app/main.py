from fastapi import FastAPI

app = FastAPI(
    title="CloudHR Portal API",
    version="1.0.0",
    description="Employee Management API built using FastAPI and AWS"
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
    
    
from sqlalchemy import text

from app.database.connection import engine

with engine.connect() as conn:
    result = conn.execute(text("SELECT 1"))
    print("Database Connection Successful:", result.scalar())
    
from app.database.connection import engine
from app.database.session import Base
from app.models.employee import Employee

Base.metadata.create_all(bind=engine)

from app.api.employee import router as employee_router

app.include_router(employee_router)