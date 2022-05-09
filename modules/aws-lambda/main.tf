resource "aws_lambda_function" "aws-lambda-function" {
  filename      = var.lambda_filename
  function_name = var.lambda_function_name
  role          = aws_iam_role.aws-lambda-iam-role.arn
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

resource "aws_iam_role" "aws-lambda-iam-role" {
  name               = "${var.lambda_function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  inline_policy {
    name   = "${var.lambda_function_name}-policy"
    policy = data.aws_iam_policy_document.aws-lambda-iam-policy-document.json
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "aws-lambda-iam-policy-document" {
  dynamic "statement" {
    for_each = var.lambda_iam_policy_statements
    content {
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

