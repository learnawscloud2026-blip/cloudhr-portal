from typing import Optional

from pydantic import BaseModel, ConfigDict


class DepartmentCreate(BaseModel):
    department_name: str
    branch: str
    company_name: str
    location: Optional[str] = None


class DepartmentUpdate(BaseModel):
    department_name: Optional[str] = None
    branch: Optional[str] = None
    company_name: Optional[str] = None
    location: Optional[str] = None
    


class DepartmentResponse(DepartmentCreate):
    id: int

    model_config = ConfigDict(from_attributes=True)