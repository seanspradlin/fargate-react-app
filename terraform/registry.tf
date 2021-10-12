resource "aws_ecr_repository" "repository" {
  name                 = "${var.project}-${var.task.name}"
  image_tag_mutability = "MUTABLE"
}
