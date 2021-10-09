output "app_url" {
  description = "Load balancer DNS name"
  value       = aws_lb.alb.dns_name
}
