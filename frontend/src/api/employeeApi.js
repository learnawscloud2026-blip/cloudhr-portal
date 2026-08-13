import apiClient from "./apiClient";

export const getEmployees = async () => {
  const response = await apiClient.get("/employees/");
  return response.data;
};

export const getEmployeeById = async (id) => {
  const response = await apiClient.get(`/employees/${id}`);
  return response.data;
};

export const createEmployee = async (employee) => {
  const response = await apiClient.post("/employees/", employee);
  return response.data;
};

export const updateEmployee = async (id, employee) => {
  const response = await apiClient.put(`/employees/${id}`, employee);
  return response.data;
};

export const deleteEmployee = async (id) => {
  const response = await apiClient.delete(`/employees/${id}`);
  return response.data;
};