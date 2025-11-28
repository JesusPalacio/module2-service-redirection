output "lambda_function_name" {
  description = "Nombre de la función Lambda"
  value       = aws_lambda_function.redirect_lambda.function_name
}

output "lambda_function_arn" {
  description = "ARN de la función Lambda"
  value       = aws_lambda_function.redirect_lambda.arn
}

output "api_endpoint" {
  value       = "${aws_api_gateway_resource.redirect_path.path_part}"
  description = "URL completa del endpoint GET"
}

output "api_id" {
  value       = data.aws_api_gateway_rest_api.existing.id
  description = "ID del API Gateway"
}

output "deployment_id" {
  value       = aws_api_gateway_deployment.deployment.id
  description = "ID del deployment actual"
}