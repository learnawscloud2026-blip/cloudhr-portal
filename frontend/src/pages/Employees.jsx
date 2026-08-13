import { useEffect, useState } from "react";

import Sidebar from "../components/Sidebar";

import {
  getEmployees,
  createEmployee,
  updateEmployee,
  deleteEmployee,
} from "../api/employeeApi";

const EMPTY_FORM = {
  first_name: "",
  last_name: "",
  email: "",
  phone: "",
  department: "",
  designation: "",
  salary: "",
};

function Employees() {
  const [employees, setEmployees] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const [showModal, setShowModal] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [saving, setSaving] = useState(false);
  const [formError, setFormError] = useState("");

  const [formData, setFormData] = useState(EMPTY_FORM);

  const loadEmployees = async () => {
    try {
      setLoading(true);

      const data = await getEmployees();

      setEmployees(data);
      setError("");
    } catch (err) {
      console.error(err);
      setError("Unable to load employees");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadEmployees();
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;

    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  const openAddModal = () => {
    setEditingId(null);
    setFormData(EMPTY_FORM);
    setFormError("");
    setShowModal(true);
  };

  const openEditModal = (employee) => {
    setEditingId(employee.id);
    setFormData({
      first_name: employee.first_name,
      last_name: employee.last_name,
      email: employee.email,
      phone: employee.phone || "",
      department: employee.department || "",
      designation: employee.designation || "",
      salary: employee.salary || "",
    });
    setFormError("");
    setShowModal(true);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    setSaving(true);
    setFormError("");

    const employeeData = {
      first_name: formData.first_name.trim(),
      last_name: formData.last_name.trim(),
      email: formData.email.trim(),
      phone: formData.phone.trim(),
      department: formData.department.trim(),
      designation: formData.designation.trim(),
      salary: Number(formData.salary),
    };

    try {
      if (editingId) {
        const updatedEmployee = await updateEmployee(editingId, employeeData);

        setEmployees((prev) =>
          prev.map((emp) =>
            emp.id === editingId ? updatedEmployee : emp
          )
        );
      } else {
        const newEmployee = await createEmployee(employeeData);

        setEmployees((prev) => [...prev, newEmployee]);
      }

      setShowModal(false);
      setFormData(EMPTY_FORM);
    } catch (err) {
      console.error("Save employee failed:", err);

      if (err.response) {
        setFormError(
          err.response.data?.detail ||
            `Failed to save employee (${err.response.status})`
        );
      } else {
        setFormError("Unable to connect to the backend API.");
      }
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (employee) => {
    const confirmed = window.confirm(
      `Delete employee ${employee.first_name} ${employee.last_name}?`
    );

    if (!confirmed) {
      return;
    }

    try {
      await deleteEmployee(employee.id);

      setEmployees((prev) =>
        prev.filter((emp) => emp.id !== employee.id)
      );
    } catch (err) {
      console.error("Delete employee failed:", err);

      setError(
        err.response?.data?.detail ||
          "Unable to delete employee"
      );
    }
  };

  const closeModal = () => {
    if (saving) {
      return;
    }

    setShowModal(false);
    setFormError("");
    setFormData(EMPTY_FORM);
    setEditingId(null);
  };

  return (
    <div className="app">

      {/* SIDEBAR */}

      <Sidebar />


      {/* MAIN CONTENT */}

      <main className="main-content">

        <header className="topbar">

          <div>

            <h1>Employees</h1>

            <p>
              Manage employee records
            </p>

          </div>


          <button
            className="primary-button"
            onClick={openAddModal}
          >
            + Add Employee
          </button>

        </header>


        {/* EMPLOYEE TABLE */}

        <section className="table-container">

          {loading && (
            <p style={{ padding: "20px" }}>
              Loading employees...
            </p>
          )}


          {error && (
            <p
              style={{
                padding: "20px",
                color: "red",
              }}
            >
              {error}
            </p>
          )}


          {!loading && !error && (

            <table>

              <thead>

                <tr>
                  <th>ID</th>
                  <th>Name</th>
                  <th>Email</th>
                  <th>Phone</th>
                  <th>Department</th>
                  <th>Designation</th>
                  <th>Salary</th>
                  <th>Actions</th>
                </tr>

              </thead>


              <tbody>

                {employees.length === 0 ? (

                  <tr>
                    <td colSpan="8">
                      No employees found
                    </td>
                  </tr>

                ) : (

                  employees.map((employee) => (

                    <tr key={employee.id}>

                      <td>
                        {employee.id}
                      </td>

                      <td>
                        {employee.first_name}{" "}
                        {employee.last_name}
                      </td>

                      <td>
                        {employee.email}
                      </td>

                      <td>
                        {employee.phone || "-"}
                      </td>

                      <td>
                        {employee.department || "-"}
                      </td>

                      <td>
                        {employee.designation || "-"}
                      </td>

                      <td>
                        {employee.salary || "-"}
                      </td>

                      <td>

                        <button
                          className="action-button edit-button"
                          onClick={() => openEditModal(employee)}
                        >
                          Edit
                        </button>

                        <button
                          className="action-button delete-button"
                          onClick={() => handleDelete(employee)}
                        >
                          Delete
                        </button>

                      </td>

                    </tr>

                  ))

                )}

              </tbody>

            </table>

          )}

        </section>

      </main>


      {/* ADD / EDIT EMPLOYEE MODAL */}

      {showModal && (

        <div
          className="modal-overlay"
          onClick={closeModal}
        >

          <div
            className="modal"
            onClick={(e) => e.stopPropagation()}
          >

            <div className="modal-header">

              <h2>
                {editingId ? "Edit Employee" : "Add Employee"}
              </h2>

              <button
                type="button"
                onClick={closeModal}
                disabled={saving}
              >
                ×
              </button>

            </div>


            {formError && (

              <div
                style={{
                  color: "red",
                  marginBottom: "15px",
                }}
              >
                {formError}
              </div>

            )}


            <form onSubmit={handleSubmit}>

              <div className="form-row">

                <div className="form-group">

                  <label>
                    First Name
                  </label>

                  <input
                    type="text"
                    name="first_name"
                    value={formData.first_name}
                    onChange={handleChange}
                    required
                  />

                </div>


                <div className="form-group">

                  <label>
                    Last Name
                  </label>

                  <input
                    type="text"
                    name="last_name"
                    value={formData.last_name}
                    onChange={handleChange}
                    required
                  />

                </div>

              </div>


              <div className="form-group">

                <label>
                  Email
                </label>

                <input
                  type="email"
                  name="email"
                  value={formData.email}
                  onChange={handleChange}
                  required
                />

              </div>


              <div className="form-group">

                <label>
                  Phone
                </label>

                <input
                  type="tel"
                  name="phone"
                  value={formData.phone}
                  onChange={handleChange}
                  required
                />

              </div>


              <div className="form-row">

                <div className="form-group">

                  <label>
                    Department
                  </label>

                  <input
                    type="text"
                    name="department"
                    value={formData.department}
                    onChange={handleChange}
                    required
                  />

                </div>


                <div className="form-group">

                  <label>
                    Designation
                  </label>

                  <input
                    type="text"
                    name="designation"
                    value={formData.designation}
                    onChange={handleChange}
                    required
                  />

                </div>

              </div>


              <div className="form-group">

                <label>
                  Salary
                </label>

                <input
                  type="number"
                  name="salary"
                  value={formData.salary}
                  onChange={handleChange}
                  min="0"
                  required
                />

              </div>


              <div className="modal-actions">

                <button
                  type="button"
                  onClick={closeModal}
                  disabled={saving}
                >
                  Cancel
                </button>

                <button
                  type="submit"
                  className="primary-button"
                  disabled={saving}
                >
                  {saving
                    ? "Saving..."
                    : editingId
                      ? "Update Employee"
                      : "Create Employee"}
                </button>

              </div>

            </form>

          </div>

        </div>

      )}

    </div>
  );
}

export default Employees;