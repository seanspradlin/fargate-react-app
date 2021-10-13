resource "aws_iam_user" "ci" {
  name = "tf-${var.project}-ci"
}

data "aws_iam_policy_document" "ci_policy" {
  statement {
    actions = [
      "iam:PassRole",
      "iam:GetRole",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeServices",
      "ecs:ListTaskDefinitions",
      "ecs:UpdateService",
      "ecs:RegisterTaskDefinition",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetLifecyclePolicy",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "ci" {
  name   = "tf-${var.project}-ci-policy"
  user   = aws_iam_user.ci.name
  policy = data.aws_iam_policy_document.ci_policy.json
}

resource "aws_iam_access_key" "ci" {
  user = aws_iam_user.ci.name
}
