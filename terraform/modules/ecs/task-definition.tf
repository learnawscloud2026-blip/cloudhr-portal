resource "aws_ecs_task_definition" "backend" {

  family = "${var.project_name}-${var.environment}-backend"

  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  cpu = "256"

  memory = "512"

  execution_role_arn = var.execution_role_arn

  task_role_arn = var.task_role_arn

  container_definitions = jsonencode([
  {
    name      = "backend"
    image     = "${var.repository_url}:latest"
    essential = true

    portMappings = [
      {
        containerPort = 8000
        hostPort      = 8000
        protocol      = "tcp"
      }
    ]

    environment = [
      {
        name  = "DATABASE_HOST"
        value = "cloudhr-dev-mysql.c0vw80mqwsk1.us-east-1.rds.amazonaws.com"
      },
      {
        name  = "DATABASE_PORT"
        value = "3306"
      },
      {
        name  = "DATABASE_NAME"
        value = "cloudhr"
      },
      {
        name  = "DATABASE_USER"
        value = "admin"
      },
      {
        name  = "DATABASE_PASSWORD"
        value = "CloudHR#123"
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"

      options = {
        awslogs-group         = aws_cloudwatch_log_group.ecs.name
        awslogs-region        = "us-east-1"
        awslogs-stream-prefix = "ecs"
      }
    }
  }
])

}
