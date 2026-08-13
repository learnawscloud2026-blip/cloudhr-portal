from typing import List
from app.core.auth import get_current_user
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.database.session import get_db
from app.core.auth import get_current_user

from app.schemas.employee import (
    EmployeeCreate,
    EmployeeResponse,
    EmployeeUpdate,
)

from app.services.employee_service import (
    create_employee,
    get_employees,
    get_employee,
    update_employee,
    delete_employee,
)


router = APIRouter(
    prefix="/employees",
    tags=["Employees"],
)


# =========================
# POST - Create Employee
# =========================

@router.post("/", response_model=EmployeeResponse)
def add_employee(
    employee: EmployeeCreate,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    return create_employee(db, employee)


# =========================
# GET - Get All Employees
# =========================

@router.get("/", response_model=List[EmployeeResponse])
def list_employees(
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    return get_employees(db)


# =========================
# GET - Get Employee By ID
# =========================

@router.get("/{employee_id}", response_model=EmployeeResponse)
def get_employee_by_id(
    employee_id: int,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    employee = get_employee(db, employee_id)

    if not employee:
        raise HTTPException(
            status_code=404,
            detail="Employee not found",
        )

    return employee


# =========================
# PUT - Update Employee
# =========================

@router.put("/{employee_id}", response_model=EmployeeResponse)
def update_employee_by_id(
    employee_id: int,
    employee: EmployeeUpdate,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    updated_employee = update_employee(
        db,
        employee_id,
        employee,
    )

    if not updated_employee:
        raise HTTPException(
            status_code=404,
            detail="Employee not found",
        )

    return updated_employee


# =========================
# DELETE - Delete Employee
# =========================

@router.delete("/{employee_id}")
def delete_employee_by_id(
    employee_id: int,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    deleted_employee = delete_employee(
        db,
        employee_id,
    )

    if not deleted_employee:
        raise HTTPException(
            status_code=404,
            detail="Employee not found",
        )

    return {
        "message": "Employee deleted successfully",
        "employee_id": employee_id,
    }