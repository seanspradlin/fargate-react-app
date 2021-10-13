output "aws_region" {
  value = var.aws_region
}

output "app_url" {
  description = "Application URL"
  value       = aws_route53_record.www.name
}

output "ci_access_key" {
  description = "AWS_ACCESS_KEY for CI"
  value       = aws_iam_access_key.ci.id
}

output "ci_secret_key" {
  description = "AWS_SECRET_ACCESS_KEY for CI"
  value       = aws_iam_access_key.ci.secret
  sensitive   = true
}

output "ecr_url" {
  description = "ECR Repository Address"
  value       = aws_ecr_repository.repository.repository_url
}

output "ecs_cluster" {
  description = "ECS Cluster Name"
  value       = aws_ecs_cluster.cluster.name
}

output "ecs_service" {
  description = "ECS Service Name"
  value       = aws_ecs_service.service.name
}
