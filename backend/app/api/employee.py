from typing import List

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database.session import get_db
from app.schemas.employee import EmployeeCreate, EmployeeResponse
from app.services.employee_service import (
    create_employee,
    get_employees,
)

router = APIRouter(
    prefix="/employees",
    tags=["Employees"],
)


@router.post("/", response_model=EmployeeResponse)
def add_employee(
    employee: EmployeeCreate,
    db: Session = Depends(get_db),
):
    return create_employee(db, employee)


@router.get("/", response_model=List[EmployeeResponse])
def list_employees(
    db: Session = Depends(get_db),
):
    return get_employees(db)