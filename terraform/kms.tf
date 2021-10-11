resource "aws_kms_key" "kms_key" {
  description             = "Encryption key for cloudwatch logs"
  deletion_window_in_days = 7
}

