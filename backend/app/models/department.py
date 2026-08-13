from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String

from app.database.session import Base


class Department(Base):

    __tablename__ = "departments"

    id = Column(Integer, primary_key=True, index=True)

    department_name = Column(String(100), nullable=False)

    branch = Column(String(100), nullable=False)

    company_name = Column(String(200), unique=True, nullable=False)

    location = Column(String(100))


    
