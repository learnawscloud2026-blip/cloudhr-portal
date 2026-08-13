output "repository_name" {
  value = aws_ecr_repository.frontend.name
}

output "repository_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "repository_arn" {
  value = aws_ecr_repository.frontend.arn
}