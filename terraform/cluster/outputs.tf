output "ecs_cluster" {
  description = "ECS Cluster Name"
  value       = aws_ecs_cluster.cluster.name
}

output "ecs_service" {
  description = "ECS Service Name"
  value       = aws_ecs_service.service.name
}
