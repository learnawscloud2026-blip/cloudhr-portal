resource "aws_ecs_service" "backend" {

  name = "${var.project_name}-${var.environment}-backend-service"

  cluster = aws_ecs_cluster.this.id

  task_definition = aws_ecs_task_definition.backend.arn

  desired_count = 1

  launch_type = "FARGATE"

  network_configuration {

    subnets = var.private_subnet_ids

    security_groups = [
      var.ecs_security_group_id
    ]

    assign_public_ip = false

  }
  load_balancer {

  target_group_arn = var.target_group_arn

  container_name   = var.container_name

  container_port   = 8000

}

}