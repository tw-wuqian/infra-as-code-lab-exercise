resource "aws_iam_role_policy_attachment" "attachment_policy" {
  policy_arn = aws_iam_policy.ecs_task_role_policy.arn
  role       = aws_iam_role.ecs_task_execution.name
}

resource "aws_iam_policy" "ecs_task_role_policy" {
  name   = format("%s-ecs-task-policy", var.prefix)
  policy = data.aws_iam_policy_document.ecs_task_role_policy_document.json
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ecs_task_role_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [var.db_secret_arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt"
    ]

    resources = [format("arn:aws:secretsmanager:%s:%s::key/%s", var.region, data.aws_caller_identity.current.id, var.db_secret_key_id)]
  }
}