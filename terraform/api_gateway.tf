data "aws_api_gateway_rest_api" "existing" {
  name = "shortener-api" 
}

resource "aws_api_gateway_resource" "redirect_path" {
  rest_api_id = data.aws_api_gateway_rest_api.existing.id
  parent_id   = data.aws_api_gateway_rest_api.existing.root_resource_id
  path_part   = "{code}"
}

resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = data.aws_api_gateway_rest_api.existing.id
  resource_id   = aws_api_gateway_resource.redirect_path.id
  http_method   = "GET"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = data.aws_api_gateway_rest_api.existing.id
  resource_id             = aws_api_gateway_resource.redirect_path.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.redirect_lambda.invoke_arn
}


resource "aws_lambda_permission" "allow_api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.redirect_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  
  source_arn = "${data.aws_api_gateway_rest_api.existing.execution_arn}/*/*"
}



resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = data.aws_api_gateway_rest_api.existing.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.redirect_path.id,
      aws_api_gateway_method.get_method.id,
      aws_api_gateway_integration.lambda_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.get_method,
    aws_api_gateway_integration.lambda_integration,
  ]
}