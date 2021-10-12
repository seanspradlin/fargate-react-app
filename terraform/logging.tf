resource "aws_kms_key" "log_encryption_key" {
  description             = "Encryption key for CloudWatch logs"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "task_logs" {
  name              = "tf-${var.project}-${var.task.name}-${var.environment}-logs"
  retention_in_days = 7
}

