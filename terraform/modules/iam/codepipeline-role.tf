data "aws_iam_policy_document" "codepipeline_assume_role" {

  statement {

    effect = "Allow"

    principals {

      type = "Service"

      identifiers = [
        "codepipeline.amazonaws.com"
      ]

    }

    actions = [
      "sts:AssumeRole"
    ]

  }

}

resource "aws_iam_role" "codepipeline" {

  name = "${var.project_name}-${var.environment}-codepipeline-role"

  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-codepipeline-role"
    }
  )

}

resource "aws_iam_policy" "codepipeline_policy" {

  name        = "${var.project_name}-${var.environment}-codepipeline-policy"
  description = "Permissions for CodePipeline"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "ecs:*"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "iam:PassRole"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "s3:*"
        ]

        Resource = "*"
      }

    ]

  })

}

resource "aws_iam_role_policy_attachment" "codepipeline_attachment" {

  role = aws_iam_role.codepipeline.name

  policy_arn = aws_iam_policy.codepipeline_policy.arn

}

