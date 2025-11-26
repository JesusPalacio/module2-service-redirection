output "api_url" {
  description = "URL base del API Gateway"
  value       = aws_api_gateway_stage.prod.invoke_url
}

output "redirect_endpoint" {
  description = "Endpoint completo para redirección"
  value       = "${aws_api_gateway_stage.prod.invoke_url}/{codigo}"
}

output "lambda_function_name" {
  description = "Nombre de la función Lambda"
  value       = aws_lambda_function.redirect_lambda.function_name
}

output "lambda_function_arn" {
  description = "ARN de la función Lambda"
  value       = aws_lambda_function.redirect_lambda.arn
}

output "api_gateway_id" {
  description = "ID del API Gateway"
  value       = aws_api_gateway_rest_api.api.id
}