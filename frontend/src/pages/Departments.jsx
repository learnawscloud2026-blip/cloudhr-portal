import { useEffect, useState } from "react";

import Sidebar from "../components/Sidebar";

import {
  getDepartments,
  createDepartment,
  updateDepartment,
  deleteDepartment,
} from "../api/departmentApi";

const EMPTY_FORM = {
  department_name: "",
  branch: "",
  company_name: "",
  location: "",
};

function Departments() {
  const [departments, setDepartments] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const [showModal, setShowModal] = useState(false);
  const [editingId, setEditingId] = useState(null);
  const [saving, setSaving] = useState(false);
  const [formError, setFormError] = useState("");

  const [formData, setFormData] = useState(EMPTY_FORM);

  const loadDepartments = async () => {
    try {
      setLoading(true);

      const data = await getDepartments();

      setDepartments(data);
      setError("");
    } catch (err) {
      console.error(err);
      setError("Unable to load departments");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadDepartments();
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

  const openEditModal = (department) => {
    setEditingId(department.id);
    setFormData({
      department_name: department.department_name,
      branch: department.branch,
      company_name: department.company_name,
      location: department.location || "",
    });
    setFormError("");
    setShowModal(true);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    setSaving(true);
    setFormError("");

    const departmentData = {
      department_name: formData.department_name.trim(),
      branch: formData.branch.trim(),
      company_name: formData.company_name.trim(),
      location: formData.location.trim(),
    };

    try {
      if (editingId) {
        const updatedDepartment = await updateDepartment(editingId, departmentData);

        setDepartments((prev) =>
          prev.map((dept) =>
            dept.id === editingId ? updatedDepartment : dept
          )
        );
      } else {
        const newDepartment = await createDepartment(departmentData);

        setDepartments((prev) => [...prev, newDepartment]);
      }

      setShowModal(false);
      setFormData(EMPTY_FORM);
    } catch (err) {
      console.error("Save department failed:", err);

      if (err.response) {
        setFormError(
          err.response.data?.detail ||
            `Failed to save department (${err.response.status})`
        );
      } else {
        setFormError("Unable to connect to the backend API.");
      }
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (department) => {
    const confirmed = window.confirm(
      `Delete department "${department.department_name}"?`
    );

    if (!confirmed) {
      return;
    }

    try {
      await deleteDepartment(department.id);

      setDepartments((prev) =>
        prev.filter((dept) => dept.id !== department.id)
      );
    } catch (err) {
      console.error("Delete department failed:", err);

      setError(
        err.response?.data?.detail ||
          "Unable to delete department"
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

            <h1>Departments</h1>

            <p>
              Manage company departments
            </p>

          </div>


          <button
            className="primary-button"
            onClick={openAddModal}
          >
            + Add Department
          </button>

        </header>


        {/* DEPARTMENT TABLE */}

        <section className="table-container">

          {loading && (
            <p style={{ padding: "20px" }}>
              Loading departments...
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
                  <th>Department</th>
                  <th>Branch</th>
                  <th>Company</th>
                  <th>Location</th>
                  <th>Actions</th>
                </tr>

              </thead>


              <tbody>

                {departments.length === 0 ? (

                  <tr>
                    <td colSpan="6">
                      No departments found
                    </td>
                  </tr>

                ) : (

                  departments.map((department) => (

                    <tr key={department.id}>

                      <td>
                        {department.id}
                      </td>

                      <td>
                        {department.department_name}
                      </td>

                      <td>
                        {department.branch || "-"}
                      </td>

                      <td>
                        {department.company_name || "-"}
                      </td>

                      <td>
                        {department.location || "-"}
                      </td>

                      <td>

                        <button
                          className="action-button edit-button"
                          onClick={() => openEditModal(department)}
                        >
                          Edit
                        </button>

                        <button
                          className="action-button delete-button"
                          onClick={() => handleDelete(department)}
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


      {/* ADD / EDIT DEPARTMENT MODAL */}

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
                {editingId ? "Edit Department" : "Add Department"}
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

              <div className="form-group">

                <label>
                  Department Name
                </label>

                <input
                  type="text"
                  name="department_name"
                  value={formData.department_name}
                  onChange={handleChange}
                  required
                />

              </div>


              <div className="form-row">

                <div className="form-group">

                  <label>
                    Branch
                  </label>

                  <input
                    type="text"
                    name="branch"
                    value={formData.branch}
                    onChange={handleChange}
                    required
                  />

                </div>


                <div className="form-group">

                  <label>
                    Company Name
                  </label>

                  <input
                    type="text"
                    name="company_name"
                    value={formData.company_name}
                    onChange={handleChange}
                    required
                  />

                </div>

              </div>


              <div className="form-group">

                <label>
                  Location
                </label>

                <input
                  type="text"
                  name="location"
                  value={formData.location}
                  onChange={handleChange}
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
                      ? "Update Department"
                      : "Create Department"}
                </button>

              </div>

            </form>

          </div>

        </div>

      )}

    </div>
  );
}

export default Departments;