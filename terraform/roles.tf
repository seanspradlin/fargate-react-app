data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_execution_policy" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetLifecyclePolicy",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "tf-${var.project}-${var.environment}-ecs-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json

  inline_policy {
    name   = "tf-${var.project}-${var.task.name}-${var.environment}-service-policy"
    policy = data.aws_iam_policy_document.ecs_task_execution_policy.json
  }
}

resource "aws_iam_role_policy_attachment" "ecs_tas_exection_role_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

