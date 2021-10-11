resource "aws_cloudwatch_log_group" "fargate_logs" {
  name              = "tf-fargate-logs"
  retention_in_days = 7
}

