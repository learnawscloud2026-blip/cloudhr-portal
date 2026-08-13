variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "certificate_arn" {
  description = "ACM certificate ARN for the HTTPS listener"
  type        = string
  default     = ""
}

variable "enable_https" {
  description = "Whether to create the HTTPS listener and redirect HTTP"
  type        = bool
  default     = false
}