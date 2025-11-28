output "lambda_function_name" {
  description = "Nombre de la función Lambda"
  value       = aws_lambda_function.redirect_lambda.function_name
}

output "lambda_function_arn" {
  description = "ARN de la función Lambda"
  value       = aws_lambda_function.redirect_lambda.arn
}