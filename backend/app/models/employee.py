from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String

from app.database.session import Base


class Employee(Base):

    __tablename__ = "employees"

    id = Column(Integer, primary_key=True, index=True)

    first_name = Column(String(100), nullable=False)

    last_name = Column(String(100), nullable=False)

    email = Column(String(200), unique=True, nullable=False)

    department = Column(String(100))

    designation = Column(String(100))

    salary = Column(Integer)
    
    phone = Column(String(10))
    
