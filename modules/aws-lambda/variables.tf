variable "lambda_filename" {
  description = "Zip/Jar filename with path."
  type        = string
}

variable "lambda_function_name" {
  description = "Name of lambda function"
  type        = string
}

variable "lambda_role_arn" {
  type = string
}

variable "lambda_handler" {
  type = string
}

variable "lambda_runtime" {
  type = string
}

variable "api_execution_arn" {
  type = string
}

variable "lambda_permission_statement_id" {
  type = string
}

variable "lambda_permission_principal" {
  type = string
}