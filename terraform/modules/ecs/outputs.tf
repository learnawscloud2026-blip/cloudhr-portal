output "cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "cluster_arn" {
  value = aws_ecs_cluster.this.arn
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs.name
}

output "task_definition_arn" {

  value = aws_ecs_task_definition.backend.arn

}

output "task_family" {

  value = aws_ecs_task_definition.backend.family

}

output "service_name" {

  value = aws_ecs_service.backend.name

}