output "app_url" {
  description = "Application URL"
  value       = aws_route53_record.www.name
}

output "public_subnets" {
  description = "List of public subnets"
  value       = [aws_subnet.primary.id, aws_subnet.secondary.id]
}

output "application_target_group_arn" {
  description = "ARN for the target group"
  value       = aws_lb_target_group.group.arn
}
