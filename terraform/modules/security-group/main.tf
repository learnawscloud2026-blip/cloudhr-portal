resource "aws_security_group" "alb" {

  name = "${var.project_name}-${var.environment}-alb-sg"

  description = "Security Group for ALB"

  vpc_id = var.vpc_id

  ingress {

    description = "HTTP"

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    description = "HTTPS"

    from_port = 443

    to_port = 443

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-alb-sg"
    }
  )

}

resource "aws_security_group" "ecs" {

  name = "${var.project_name}-${var.environment}-ecs-sg"

  description = "Security Group for ECS"

  vpc_id = var.vpc_id

  ingress {
    description = "Application Traffic - Backend"

    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]
  }

  ingress {
    description = "Application Traffic - Frontend"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "rds" {

  name = "${var.project_name}-${var.environment}-rds-sg"

  description = "Security Group for RDS"

  vpc_id = var.vpc_id

  ingress {

    description = "MySQL"

    from_port = 3306

    to_port = 3306

    protocol = "tcp"

    security_groups = [
      aws_security_group.ecs.id
    ]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-rds-sg"
    }
  )

}

resource "aws_security_group" "bastion" {

  name = "${var.project_name}-${var.environment}-bastion-sg"

  description = "Security Group for Bastion"

  vpc_id = var.vpc_id

  ingress {

    description = "SSH"

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = [
      var.my_ip
    ]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-bastion-sg"
    }
  )

}

