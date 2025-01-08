# IAM Policy for SNS Publish
data "aws_caller_identity" "current" {}



data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}