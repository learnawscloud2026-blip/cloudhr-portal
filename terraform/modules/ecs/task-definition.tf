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

      name = "backend"

      image = "${var.repository_url}:v1"

      essential = true

      portMappings = [

        {

          containerPort = 8000

          hostPort = 8000

          protocol = "tcp"

        }

      ]

      logConfiguration = {

        logDriver = "awslogs"

        options = {

          awslogs-group = aws_cloudwatch_log_group.ecs.name

          awslogs-region = "us-east-1"

          awslogs-stream-prefix = "ecs"

        }

      }

    }

  ])

}