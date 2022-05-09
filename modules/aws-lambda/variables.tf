variable "lambda_filename" {
  description = "Zip/Jar filename with path."
  type        = string
}

variable "lambda_function_name" {
  description = "Name of lambda function"
  type        = string
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

variable "lambda_iam_policy_statements" {
  description = "Map of dynamic policy statements to attach to Lambda Function role"
  type        = any
  default     = {
    logs = {
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      resources = ["*"]
    }
  }
}