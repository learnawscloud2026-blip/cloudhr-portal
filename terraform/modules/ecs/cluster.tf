resource "aws_ecs_cluster" "this" {

  name = "${var.project_name}-${var.environment}-cluster"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-cluster"
    }
  )

}

resource "aws_cloudwatch_log_group" "ecs" {

  name = "/ecs/${var.project_name}-${var.environment}"

  retention_in_days = 30

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-logs"
    }
  )

}