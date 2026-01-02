# API Gateway Configuration for REST API
# Defines the REST API endpoint and its integration with Lambda functions

resource "aws_apigateway_rest_api" "serverless_api" {
  name        = "${var.project_name}-api"
  description = "Serverless REST API for Todo Management"
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Name = "${var.project_name}-api"
  }
}

# /todos resource
resource "aws_apigateway_resource" "todos" {
  rest_api_id = aws_apigateway_rest_api.serverless_api.id
  parent_id   = aws_apigateway_rest_api.serverless_api.root_resource_id
  path_part   = "todos"
}

# /todos/{id} resource
resource "aws_apigateway_resource" "todo_by_id" {
  rest_api_id = aws_apigateway_rest_api.serverless_api.id
  parent_id   = aws_apigateway_resource.todos.id
  path_part   = "{id}"
}

# POST /todos - Create Todo
resource "aws_apigateway_method" "create_todo" {
  rest_api_id      = aws_apigateway_rest_api.serverless_api.id
  resource_id      = aws_apigateway_resource.todos.id
  http_method      = "POST"
  authorization    = "NONE"
}

resource "aws_apigateway_integration" "create_todo" {
  rest_api_id      = aws_apigateway_rest_api.serverless_api.id
  resource_id      = aws_apigateway_resource.todos.id
  http_method      = aws_apigateway_method.create_todo.http_method
  type             = "AWS_PROXY"
  integration_http_method = "POST"
  uri              = aws_lambda_function.create_todo.invoke_arn
}

# GET /todos - Read All Todos
resource "aws_apigateway_method" "read_todos" {
  rest_api_id      = aws_apigateway_rest_api.serverless_api.id
  resource_id      = aws_apigateway_resource.todos.id
  http_method      = "GET"
  authorization    = "NONE"
}

resource "aws_apigateway_integration" "read_todos" {
  rest_api_id      = aws_apigateway_rest_api.serverless_api.id
  resource_id      = aws_apigateway_resource.todos.id
  http_method      = aws_apigateway_method.read_todos.http_method
  type             = "AWS_PROXY"
  integration_http_method = "POST"
  uri              = aws_lambda_function.read_todo.invoke_arn
}

# GET /todos/{id} - Read Specific Todo
resource "aws_apigateway_method" "read_todo_by_id" {
  rest_api_id      = aws_apigateway_rest_api.serverless_api.id
  resource_id      = aws_apigateway_resource.todo_by_id.id
  http_method      = "GET"
  authorization    = "NONE"
}

resource "aws_apigateway_integration" "read_todo_by_id" {
  rest_api_id      = aws_apigateway_rest_api.serverless_api.id
  resource_id      = aws_apigateway_resource.todo_by_id.id
  http_method      = aws_apigateway_method.read_todo_by_id.http_method
  type             = "AWS_PROXY"
  integration_http_method = "POST"
  uri              = aws_lambda_function.read_todo.invoke_arn
}

# PUT /todos/{id} - Update Todo
resource "aws_apigateway_method" "update_todo" {
  rest_api_id      = aws_apigateway_rest_api.serverless_api.id
  resource_id      = aws_apigateway_resource.todo_by_id.id
  http_method      = "PUT"
  authorization    = "NONE"
}

resource "aws_apigateway_integration" "update_todo" {
  rest_api_id      = aws_apigateway_rest_api.serverless_api.id
  resource_id      = aws_apigateway_resource.todo_by_id.id
  http_method      = aws_apigateway_method.update_todo.http_method
  type             = "AWS_PROXY"
  integration_http_method = "POST"
  uri              = aws_lambda_function.update_todo.invoke_arn
}

# DELETE /todos/{id} - Delete Todo
resource "aws_apigateway_method" "delete_todo" {
  rest_api_id      = aws_apigateway_rest_api.serverless_api.id
  resource_id      = aws_apigateway_resource.todo_by_id.id
  http_method      = "DELETE"
  authorization    = "NONE"
}

resource "aws_apigateway_integration" "delete_todo" {
  rest_api_id      = aws_apigateway_rest_api.serverless_api.id
  resource_id      = aws_apigateway_resource.todo_by_id.id
  http_method      = aws_apigateway_method.delete_todo.http_method
  type             = "AWS_PROXY"
  integration_http_method = "POST"
  uri              = aws_lambda_function.delete_todo.invoke_arn
}

# API Gateway Deployment
resource "aws_apigateway_deployment" "api" {
  rest_api_id = aws_apigateway_rest_api.serverless_api.id

  depends_on = [
    aws_apigateway_integration.create_todo,
    aws_apigateway_integration.read_todos,
    aws_apigateway_integration.read_todo_by_id,
    aws_apigateway_integration.update_todo,
    aws_apigateway_integration.delete_todo,
  ]
}

# API Gateway Stage
resource "aws_apigateway_stage" "api" {
  deployment_id = aws_apigateway_deployment.api.id
  rest_api_id   = aws_apigateway_rest_api.serverless_api.id
  stage_name    = var.environment

  access_log_settings {
    cloudwatch_log_group_arn = "${aws_cloudwatch_log_group.api_gateway_logs.arn}:*"
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.resourcePath"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }

  depends_on = [aws_cloudwatch_log_group.api_gateway_logs]
}

# Lambda permissions for API Gateway
resource "aws_lambda_permission" "api_gateway_create" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_todo.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigateway_rest_api.serverless_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_read" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.read_todo.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigateway_rest_api.serverless_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_update" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_todo.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigateway_rest_api.serverless_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_delete" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_todo.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigateway_rest_api.serverless_api.execution_arn}/*/*"
}
