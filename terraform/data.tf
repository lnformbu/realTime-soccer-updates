# IAM Policy for SNS Publish
data "aws_caller_identity" "current" {}



data "archive_file" "lambda" {
  type        = "zip"
  source_file = "soccer_notifications.py"
  output_path = "soccer_notifications.zip"
}