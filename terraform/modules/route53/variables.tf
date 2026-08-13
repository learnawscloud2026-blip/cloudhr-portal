variable "domain_name" {
  description = "Domain name for the Route 53 hosted zone"
  type        = string
}

variable "alb_dns_name" {
  description = "ALB DNS name to point records at"
  type        = string
}

variable "alb_zone_id" {
  description = "Canonical hosted zone ID of the ALB"
  type        = string
}

variable "common_tags" {
  description = "Common Tags"
  type        = map(string)
}