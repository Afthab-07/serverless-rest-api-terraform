# Lambda Functions Configuration
# Defines all CRUD Lambda functions for the REST API

# Data archive for Lambda function code
data "archive_file" "lambda_functions" {
  for_each = {
    create_todo = "lambda_functions/create_todo.py"
    read_todo   = "lambda_functions/read_todo.py"
    update_todo = "lambda_functions/update_todo.py"
    delete_todo = "lambda_functions/delete_todo.py"
  }

  type        = "zip"
  source_file = each.value
  output_path = "${path.module}/lambda_${each.key}.zip"
}

# CREATE Todo Lambda Function
resource "aws_lambda_function" "create_todo" {
  filename         = data.archive_file.lambda_functions["create_todo"].output_path
  function_name    = "${var.project_name}-create-todo"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "create_todo.lambda_handler"
  runtime          = "python3.11"
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory
  source_code_hash = data.archive_file.lambda_functions["create_todo"].output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.todos.name
    }
  }

  depends_on = [aws_iam_role_policy.lambda_dynamodb_policy]

  tags = {
    Name = "${var.project_name}-create-todo"
  }
}

# READ Todo Lambda Function
resource "aws_lambda_function" "read_todo" {
  filename         = data.archive_file.lambda_functions["read_todo"].output_path
  function_name    = "${var.project_name}-read-todo"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "read_todo.lambda_handler"
  runtime          = "python3.11"
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory
  source_code_hash = data.archive_file.lambda_functions["read_todo"].output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.todos.name
    }
  }

  depends_on = [aws_iam_role_policy.lambda_dynamodb_policy]

  tags = {
    Name = "${var.project_name}-read-todo"
  }
}

# UPDATE Todo Lambda Function
resource "aws_lambda_function" "update_todo" {
  filename         = data.archive_file.lambda_functions["update_todo"].output_path
  function_name    = "${var.project_name}-update-todo"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "update_todo.lambda_handler"
  runtime          = "python3.11"
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory
  source_code_hash = data.archive_file.lambda_functions["update_todo"].output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.todos.name
    }
  }

  depends_on = [aws_iam_role_policy.lambda_dynamodb_policy]

  tags = {
    Name = "${var.project_name}-update-todo"
  }
}

# DELETE Todo Lambda Function
resource "aws_lambda_function" "delete_todo" {
  filename         = data.archive_file.lambda_functions["delete_todo"].output_path
  function_name    = "${var.project_name}-delete-todo"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "delete_todo.lambda_handler"
  runtime          = "python3.11"
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory
  source_code_hash = data.archive_file.lambda_functions["delete_todo"].output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.todos.name
    }
  }

  depends_on = [aws_iam_role_policy.lambda_dynamodb_policy]

  tags = {
    Name = "${var.project_name}-delete-todo"
  }
}
