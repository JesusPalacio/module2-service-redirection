resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 7

  tags = {
    Module = "Redirect Service"
  }
}

resource "aws_lambda_function" "redirect_lambda" {
  function_name = var.lambda_name
  handler       = "handler.handler"
  runtime       = "nodejs18.x"
  timeout       = 10
  memory_size   = 256

  filename         = "${path.module}/../lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda.zip")

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }

  tags = {
    Module    = "Redirect Service"
    ManagedBy = "Terraform"
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_logs,
    aws_iam_role_policy_attachment.attach
  ]
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.redirect_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}