resource "aws_iam_user" "github" {
  name = "tf-github-publisher"
}

resource "aws_iam_user_policy" "github" {
  name   = "tf_github_policy"
  user   = aws_iam_user.github.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
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
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_access_key" "github" {
  user = aws_iam_user.github.name
}

resource "aws_ecr_repository" "repository" {
  name                 = "tf-fargate-demo"
  image_tag_mutability = "MUTABLE"
}
