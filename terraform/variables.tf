variable "table_name" {
  type        = string
  description = "Nombre de la tabla DynamoDB compartida"
}

variable "lambda_name" {
  type        = string
  description = "Nombre de la lambda de redirección"
}

variable "api_id" {
  type = string
}

variable "root_id" {
  type = string
}

variable "api_execution_arn" {
  type = string
}