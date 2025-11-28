resource "aws_api_gateway_resource" "redirect_path" {
  rest_api_id = var.api_id
  parent_id   = var.root_id
  path_part   = "{code}"
}

resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = var.api_id
  resource_id   = aws_api_gateway_resource.redirect_path.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = var.api_id
  resource_id = aws_api_gateway_resource.redirect_path.id
  http_method = aws_api_gateway_method.get_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.redirect_lambda.invoke_arn
}

resource "aws_lambda_permission" "allow_api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.redirect_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${var.api_execution_arn}/*/*"
}