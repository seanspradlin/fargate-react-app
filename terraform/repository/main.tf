resource "aws_iam_user" "github" {
  name = "tf-github-publisher"
}

resource "aws_iam_access_key" "github" {
  user = aws_iam_user.github.name
}

resource "aws_ecr_repository" "repository" {
  name                 = "tf-fargate-demo"
  image_tag_mutability = "MUTABLE"
}
