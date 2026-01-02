# Terraform Outputs for Serverless REST API
# These outputs provide important information about deployed resources

output "api_endpoint" {
  description = "Base URL for the REST API"
  value       = aws_apigateway_deployment.api.invoke_url
}

output "api_gateway_id" {
  description = "API Gateway ID"
  value       = aws_apigateway_rest_api.serverless_api.id
}

output "dynamodb_table_name" {
  description = "DynamoDB table name for todos"
  value       = aws_dynamodb_table.todos.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.todos.arn
}

output "lambda_create_function_arn" {
  description = "ARN of the Create Todo Lambda function"
  value       = aws_lambda_function.create_todo.arn
}

output "lambda_read_function_arn" {
  description = "ARN of the Read Todo Lambda function"
  value       = aws_lambda_function.read_todo.arn
}

output "lambda_update_function_arn" {
  description = "ARN of the Update Todo Lambda function"
  value       = aws_lambda_function.update_todo.arn
}

output "lambda_delete_function_arn" {
  description = "ARN of the Delete Todo Lambda function"
  value       = aws_lambda_function.delete_todo.arn
}

output "cloudwatch_log_group_lambda" {
  description = "CloudWatch log group for Lambda functions"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}

output "cloudwatch_log_group_api_gateway" {
  description = "CloudWatch log group for API Gateway"
  value       = aws_cloudwatch_log_group.api_gateway_logs.name
}

output "lambda_execution_role_arn" {
  description = "ARN of Lambda execution IAM role"
  value       = aws_iam_role.lambda_execution_role.arn
}

output "deployment_status" {
  description = "Deployment status information"
  value = {
    environment = var.environment
    region      = var.aws_region
    project     = var.project_name
    deployed_at = timestamp()
  }
}
