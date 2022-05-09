module "tf-get-user-photos" {
  source = "./modules/aws-lambda"

  lambda_filename      = "zips/get-user-photos.jar"
  lambda_function_name = "${var.app-prefix}get-user-photos"
  lambda_handler       = "com.example.LambdaRequestHandler::handleRequest"

  lambda_runtime                 = "java11"
  api_execution_arn              = aws_apigatewayv2_api.tf-upskill-api.execution_arn
  lambda_permission_statement_id = "AllowExecutionFromAPIGateway"
  lambda_permission_principal    = "apigateway.amazonaws.com"

  lambda_iam_policy_statements = {
    s3 = {
      actions   = ["s3:List*"]
      resources = ["arn:aws:s3:::${var.s3_bucket_name}"]
    }
  }
}

module "tf-save-file-info" {
  source = "./modules/aws-lambda"

  lambda_filename      = "zips/save-file-info.jar"
  lambda_function_name = "${var.app-prefix}save-file-info"
  lambda_handler       = "com.example.SaveFileInfoHandler::handleRequest"

  lambda_runtime                 = "java11"
  api_execution_arn              = module.tf-upskill-bucket.bucket_arn
  lambda_permission_statement_id = "AllowExecutionFromS3Bucket"
  lambda_permission_principal    = "s3.amazonaws.com"

  lambda_iam_policy_statements = {
    logs = {
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      resources = ["*"]
    },
    dynamodb = {
      actions   = ["dynamodb:PutItem"]
      resources = ["arn:aws:dynamodb:${var.region}:${var.account_id}:table/${var.table_name}"]
    },
    sns = {
      actions   = ["SNS:Publish"]
      resources = ["arn:aws:sns:${var.region}:${var.account_id}:${var.notification-topic}"]
    }
  }
}

module "tf-get-presigned-url" {
  source = "./modules/aws-lambda"

  lambda_filename      = "zips/get-presigned-url.jar"
  lambda_function_name = "${var.app-prefix}get-presigned-url"
  lambda_handler       = "com.example.LambdaRequestHandler::handleRequest"

  lambda_runtime                 = "java11"
  api_execution_arn              = aws_apigatewayv2_api.tf-upskill-api.execution_arn
  lambda_permission_statement_id = "AllowExecutionFromAPIGateway"
  lambda_permission_principal    = "apigateway.amazonaws.com"
}

module "tf-process-photo" {
  source = "./modules/aws-lambda"

  lambda_filename      = "zips/process-photo.jar"
  lambda_function_name = "${var.app-prefix}process-photo"
  lambda_handler       = "com.example.LambdaRequestHandler::handleRequest"

  lambda_runtime                 = "java11"
  api_execution_arn              = aws_apigatewayv2_api.tf-upskill-api.execution_arn
  lambda_permission_statement_id = "AllowExecutionFromAPIGateway"
  lambda_permission_principal    = "apigateway.amazonaws.com"

  lambda_iam_policy_statements = {
    logs = {
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      resources = ["*"]
    },
    s3 = {
      actions   = ["s3:PutObject", "s3:GetObject"]
      resources = ["arn:aws:s3:::${var.s3_bucket_name}/*"]
    }
  }
}

module "tf-lambda-authorizer" {
  source = "./modules/aws-lambda"

  lambda_filename      = "zips/lambda-authorizer.zip"
  lambda_function_name = "${var.app-prefix}lambda-authorizer"
  lambda_handler       = "index.handler"

  lambda_runtime                 = "nodejs14.x"
  api_execution_arn              = aws_apigatewayv2_api.tf-upskill-api.execution_arn
  lambda_permission_statement_id = "AllowExecutionFromAPIGateway"
  lambda_permission_principal    = "apigateway.amazonaws.com"
}
