output "aws_region" {
  value = "us-east-1"
}

output "app_url" {
  description = "Application URL"
  value       = module.network.app_url
}

output "github_access_key" {
  description = "AWS_ACCESS_KEY for GitHub Actions"
  value       = module.repository.github_access_key
}

output "github_secret_key" {
  description = "AWS_SECRET_ACCESS_KEY for GitHub Actions"
  value       = module.repository.github_secret_key
  sensitive   = true
}

output "ecr_url" {
  description = "ECR Repository Address"
  value       = module.repository.ecr_url
}

output "ecs_cluster" {
  description = "ECS Cluster Name"
  value       = module.cluster.ecs_cluster
}

output "ecs_service" {
  description = "ECS Service Name"
  value       = module.cluster.ecs_service
}
