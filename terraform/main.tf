
# SNS Topic
resource "aws_sns_topic" "soccer_topic" {
  name = "soccer_topic"
}

# SNS Topic Subscriptions
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.soccer_topic.arn
  protocol  = "email"
  endpoint  = "lenonnformbui@gmail.com" #"your-email@example.com" # Replace with your email
}

resource "aws_sns_topic_subscription" "sms_subscription" {
  topic_arn = aws_sns_topic.soccer_topic.arn
  protocol  = "sms"
  endpoint  = "+12407791158" #"+1234567890" # Replace with your phone number
}


resource "aws_iam_policy" "sns_publish_policy" {
  name        = "soccer_sns_policy"
  description = "Policy to allow SNS Publish"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sns:Publish"
        Resource = aws_sns_topic.soccer_topic.arn
      }
    ]
  })
}

# IAM Role for Lambda
resource "aws_iam_role" "soccer_role" {
  name               = "soccer_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach policies to the IAM Role
resource "aws_iam_role_policy_attachment" "attach_sns_publish_policy" {
  role       = aws_iam_role.soccer_role.name
  policy_arn = aws_iam_policy.sns_publish_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_lambda_basic_execution" {
  role       = aws_iam_role.soccer_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# Lambda Function
resource "aws_lambda_function" "soccer_notifications" {
  function_name = "soccer_notifications"
  role          = aws_iam_role.soccer_role.arn
  runtime       = "python3.9"
  handler       = "lambda_function.lambda_handler"
  environment {
    variables = {
      SOCCER_API_KEY    = var.soccer_api_key #"your-soccer-api-key" # Replace with your actual SOCCER API key
      SNS_TOPIC_ARN  = aws_sns_topic.soccer_topic.arn
      COMPETITIONS     = "EPL,MLS" 
    }
  }
  
  filename         = "soccer_notifications.zip" # Provide the path to your zipped Lambda code
  source_code_hash = data.archive_file.lambda.output_base64sha256
}

# EventBridge Rule for Scheduling
resource "aws_cloudwatch_event_rule" "schedule_rule" {
  name        = "soccer_event_rule"
  schedule_expression = "rate(1 hour)" # Change the schedule as needed
}

# EventBridge Target
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.schedule_rule.name
  target_id = "soccer_notifications_target"
  arn       = aws_lambda_function.soccer_notifications.arn
}

# Permission for EventBridge to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.soccer_notifications.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule_rule.arn
}
