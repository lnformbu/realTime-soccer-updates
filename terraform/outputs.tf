# Output for the SNS Topic
output "sns_topic_arn" {
  description = "ARN of the SNS Topic"
  value       = aws_sns_topic.soccer_topic.arn
}

# Output for Email Subscription
output "sns_email_subscription" {
  description = "ARN of the email subscription to the SNS Topic"
  value       = aws_sns_topic_subscription.email_subscription.id
}

# Output for SMS Subscription
output "sns_sms_subscription" {
  description = "ARN of the SMS subscription to the SNS Topic"
  value       = aws_sns_topic_subscription.sms_subscription.id
}

# Output for SNS Publish Policy
output "sns_publish_policy_arn" {
  description = "ARN of the SNS Publish Policy"
  value       = aws_iam_policy.sns_publish_policy.arn
}

# Output for IAM Role
output "iam_role_arn" {
  description = "ARN of the IAM Role for Lambda"
  value       = aws_iam_role.soccer_role.arn
}

# Output for Lambda Function
output "lambda_function_arn" {
  description = "ARN of the Lambda Function"
  value       = aws_lambda_function.soccer_notifications.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda Function"
  value       = aws_lambda_function.soccer_notifications.function_name
}

# Output for EventBridge Rule
output "eventbridge_rule_arn" {
  description = "ARN of the EventBridge Rule"
  value       = aws_cloudwatch_event_rule.schedule_rule.arn
}

# Output for EventBridge Target
output "eventbridge_target_id" {
  description = "ID of the EventBridge Target"
  value       = aws_cloudwatch_event_target.lambda_target.target_id
}
