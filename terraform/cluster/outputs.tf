output "ecs_cluster" {
  description = "ECS Cluster Name"
  value       = aws_ecs_cluster.cluster.name
}

output "ecs_service" {
  description = "ECS Service Name"
  value       = aws_ecs_service.service.name
}

output "ecs_service_arn" {
  description = "ECS Service ARN"
  value       = aws_ecs_service.service.id
}

output "ecs_service_role_arn" {
  description = "Service Role ARN"
  value       = aws_iam_role.fargate.arn
}

