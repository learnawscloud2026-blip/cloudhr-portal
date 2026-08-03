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