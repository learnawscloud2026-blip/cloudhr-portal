output "subnet_ids" {
  value = {
    for key, subnet in aws_subnet.this :
    key => subnet.id
  }
}

output "public_subnet_ids" {
  description = "List of Public Subnet IDs"

  value = [
    aws_subnet.this["public-a"].id,
    aws_subnet.this["public-b"].id
  ]
}

output "private_app_subnet_ids" {
  description = "List of Private App Subnet IDs"

  value = [
    aws_subnet.this["private-app-a"].id,
    aws_subnet.this["private-app-b"].id
  ]
}

output "private_db_subnet_ids" {
  description = "List of Private DB Subnet IDs"

  value = [
    aws_subnet.this["private-db-a"].id,
    aws_subnet.this["private-db-b"].id
  ]
}