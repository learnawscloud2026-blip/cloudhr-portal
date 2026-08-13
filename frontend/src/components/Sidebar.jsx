import { NavLink } from "react-router-dom";

import { useAuth } from "../context/AuthContext";

function Sidebar() {
  const { logout } = useAuth();

  const navItems = [
    { to: "/dashboard", label: "Dashboard" },
    { to: "/employees", label: "Employees" },
    { to: "/departments", label: "Departments" },
  ];

  return (
    <aside className="sidebar">

      <div className="logo">
        CloudHR
      </div>

      <nav>

        {navItems.map((item) => (
          <NavLink
            key={item.to}
            to={item.to}
            className={({ isActive }) =>
              isActive ? "active" : ""
            }
          >
            {item.label}
          </NavLink>
        ))}

      </nav>

      <div className="sidebar-footer">

        <button
          className="logout-button"
          onClick={logout}
        >
          Logout
        </button>

      </div>

    </aside>
  );
}

export default Sidebar;