variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_db_subnet_ids" {
  type = list(string)
}

variable "rds_security_group_id" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "db_name" {
  type = string
  default = "cloudhr"
}

variable "db_username" {
  type = string
  default = "admin"
}

variable "db_password" {
  type      = string
  sensitive = true
}

