resource "aws_ecr_repository" "repository" {
  name                 = "tf-fargate-demo"
  image_tag_mutability = "MUTABLE"
}
