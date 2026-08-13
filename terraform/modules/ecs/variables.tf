variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "common_tags" {
  type = map(string)
}


variable "execution_role_arn" {
  description = "ECS Task Execution Role ARN"
  type        = string
}

variable "task_role_arn" {
  description = "ECS Task Role ARN"
  type        = string
}

variable "repository_url" {
  description = "Amazon ECR Repository URL"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private Application Subnets"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "ECS Security Group"
  type        = string
}

variable "target_group_arn" {
  type = string
}

variable "container_name" {
  type = string
}

variable "frontend_repository_url" {
  description = "Frontend ECR Repository URL"
  type        = string
}

variable "frontend_target_group_arn" {
  description = "Frontend ALB Target Group ARN"
  type        = string
}
