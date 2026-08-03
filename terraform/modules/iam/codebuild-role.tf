data "aws_iam_policy_document" "codebuild_assume_role" {

  statement {

    effect = "Allow"

    principals {

      type = "Service"

      identifiers = [
        "codebuild.amazonaws.com"
      ]

    }

    actions = [
      "sts:AssumeRole"
    ]

  }

}

resource "aws_iam_role" "codebuild" {

  name = "${var.project_name}-${var.environment}-codebuild-role"

  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-codebuild-role"
    }
  )
}

resource "aws_iam_policy" "codebuild_policy" {

  name = "${var.project_name}-${var.environment}-codebuild-policy"

  description = "Permissions for CodeBuild"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "logs:*"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:BatchGetImage"
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

resource "aws_iam_role_policy_attachment" "codebuild_attachment" {

  role = aws_iam_role.codebuild.name

  policy_arn = aws_iam_policy.codebuild_policy.arn

}

