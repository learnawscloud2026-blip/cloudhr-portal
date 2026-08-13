resource "aws_lb" "this" {

  name               = "${var.project_name}-${var.environment}-alb"

  internal           = false

  load_balancer_type = "application"

  security_groups = [
    var.alb_security_group_id
  ]

  subnets = var.public_subnet_ids

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-alb"
    }
  )
}

resource "aws_lb_target_group" "backend" {

  name = "${var.project_name}-${var.environment}-tg"

  port = 8000

  protocol = "HTTP"

  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {

    enabled = true

    path = "/health"

    protocol = "HTTP"

    matcher = "200"

    interval = 30

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 2

  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-tg"
    }
  )

}

resource "aws_lb_target_group" "frontend" {

  name = "${var.project_name}-${var.environment}-frontend-tg"

  port = 80

  protocol = "HTTP"

  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {

    enabled = true

    path = "/"

    protocol = "HTTP"

    matcher = "200"

    interval = 30

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 2
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-frontend-tg"
    }
  )
}

locals {
  spa_listener_arn = var.enable_https ? aws_lb_listener.https[0].arn : aws_lb_listener.http.arn
}

resource "aws_lb_listener_rule" "frontend" {

  listener_arn = local.spa_listener_arn

  priority = 10

  action {
    type = "forward"

    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    path_pattern {
      values = ["/", "/assets/*"]
    }
  }
}

resource "aws_lb_listener_rule" "spa" {

  listener_arn = local.spa_listener_arn

  priority = 20

  action {
    type = "forward"

    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    path_pattern {
      values = [
        "/dashboard",
        "/employees",
        "/departments",
        "/login",
      ]
    }
  }
}

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.this.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = var.enable_https ? "redirect" : "forward"

    dynamic "redirect" {
      for_each = var.enable_https ? [1] : []

      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    dynamic "forward" {
      for_each = var.enable_https ? [] : [1]

      content {
        target_group {
          arn = aws_lb_target_group.backend.arn
        }
      }
    }

  }

}

resource "aws_lb_listener" "https" {

  count = var.enable_https ? 1 : 0

  load_balancer_arn = aws_lb.this.arn

  port = 443

  protocol = "HTTPS"

  certificate_arn = var.certificate_arn

  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.backend.arn

  }

}