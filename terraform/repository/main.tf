resource "aws_iam_user" "github" {
  name = "tf-github-publisher"
}

resource "aws_iam_user_policy" "github" {
  name = "tf_github_policy"
  user = aws_iam_user.github.name
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "GetAuthorizationToken",
        Effect : "Allow",
        Action : [
          "ecr:GetAuthorizationToken"
        ],
        Resource : "*"
      },
      {
        Sid : "AllowPush",
        Effect : "Allow",
        Action : [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ],
        Resource : aws_ecr_repository.repository.arn
      },
      {
        Sid : "GetTaskDetails",
        Effect : "Allow",
        Action : [
          "ecs:RegisterTaskDefinition",
          "ecs:ListTaskDefinitions",
          "ecs:DescribeTaskDefinition",
          "ecs:UpdateService"
        ],
        Resource : "*"
      },
      {
        Sid : "DeployService",
        Effect : "Allow",
        Action : [
          "ecs:DescribeServices",
          "ecs:UpdateService"
        ],
        Resource : "${var.service_arn}"
      },
      {
        Sid : "PassRolesInTaskDefinitions",
        Effect : "Allow",
        Action : [
          "iam:PassRole"
        ],
        Resource : "${var.service_role_arn}"
      }
    ]
  })
  depends_on = [aws_ecr_repository.repository]
}


resource "aws_iam_access_key" "github" {
  user = aws_iam_user.github.name
}

resource "aws_ecr_repository" "repository" {
  name                 = "tf-fargate-demo"
  image_tag_mutability = "MUTABLE"
}
