import { useEffect, useState } from "react";
import { Link } from "react-router-dom";

import Sidebar from "../components/Sidebar";

import { getEmployees } from "../api/employeeApi";
import { getDepartments } from "../api/departmentApi";

function Dashboard() {
  const [employeeCount, setEmployeeCount] = useState(null);
  const [departmentCount, setDepartmentCount] = useState(null);
  const [apiStatus, setApiStatus] = useState("checking");

  useEffect(() => {
    const loadStats = async () => {
      try {
        const employees = await getEmployees();
        const departments = await getDepartments();

        setEmployeeCount(employees.length);
        setDepartmentCount(departments.length);
        setApiStatus("online");
      } catch (err) {
        console.error(err);
        setApiStatus("offline");
      }
    };

    loadStats();
  }, []);

  const cards = [
    {
      title: "Employees",
      value: employeeCount,
      description: "Manage employee records",
      link: "/employees",
      linkLabel: "View Employees →",
    },
    {
      title: "Departments",
      value: departmentCount,
      description: "Manage company departments",
      link: "/departments",
      linkLabel: "View Departments →",
    },
    {
      title: "System Status",
      value: apiStatus === "online" ? "● Online" : apiStatus === "offline" ? "● Offline" : "● Checking",
      description: "Backend API",
      link: null,
      linkLabel: null,
    },
  ];

  return (
    <div className="app">

      <Sidebar />

      <main className="main-content">

        <header className="topbar">

          <div>
            <h1>Dashboard</h1>
            <p>Welcome to CloudHR Portal</p>
          </div>

          <div className="user">
            Admin
          </div>

        </header>

        <section className="cards">

          {cards.map((card) => (
            <div className="card" key={card.title}>

              <h3>{card.title}</h3>

              <p className="card-value">
                {card.value === null ? "—" : card.value}
              </p>

              <p>{card.description}</p>

              {card.link ? (
                <Link to={card.link}>
                  {card.linkLabel}
                </Link>
              ) : (
                <span className="status">
                  {card.value}
                </span>
              )}

            </div>
          ))}

        </section>

      </main>

    </div>
  );
}

export default Dashboard;