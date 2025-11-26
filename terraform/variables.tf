variable "table_name" {
  type        = string
  description = "Nombre de la tabla DynamoDB compartida"
}

variable "lambda_name" {
  type    = string
  default = "redirect-service"
}
