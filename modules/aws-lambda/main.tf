resource "aws_lambda_function" "aws-lambda-function" {
  filename      = var.lambda_filename
  function_name = var.lambda_function_name
  role          = var.lambda_role_arn
  handler       = var.lambda_handler

  source_code_hash = filebase64sha256(var.lambda_filename)
  runtime          = var.lambda_runtime
  timeout          = 120
  memory_size      = 512
}

resource "aws_lambda_permission" "aws-lambda-permission" {
  statement_id  = var.lambda_permission_statement_id
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws-lambda-function.function_name
  principal     = var.lambda_permission_principal

  source_arn = "${var.api_execution_arn}/*/*"
}


