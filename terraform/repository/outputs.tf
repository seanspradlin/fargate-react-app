output "github_access_key" {
  description = "AWS_ACCESS_KEY for GitHub Actions"
  value       = aws_iam_access_key.github.id
}

output "github_secret_key" {
  description = "AWS_SECRET_ACCESS_KEY for GitHub Actions"
  value       = aws_iam_access_key.github.secret
  sensitive   = true
}

output "ecr_url" {
  description = "ECR Repository Address"
  value       = aws_ecr_repository.repository.repository_url
}
