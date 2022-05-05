module "tf-get-user-photos"{
  source = "./modules/aws-lambda"

  lambda_filename = "zips/get-user-photos.jar"
  lambda_function_name = "tf-get-user-photos"
  lambda_role_arn = aws_iam_role.get-user-photos.arn
  lambda_handler = "com.example.LambdaRequestHandler::handleRequest"

  lambda_runtime = "java11"
  api_execution_arn = aws_apigatewayv2_api.tf-upskill-api.execution_arn
  lambda_permission_statement_id = "AllowExecutionFromAPIGateway"
  lambda_permission_principal = "apigateway.amazonaws.com"
}

module "tf-save-file-info"{
  source = "./modules/aws-lambda"

  lambda_filename = "zips/save-file-info.jar"
  lambda_function_name = "tf-save-file-info"
  lambda_role_arn = aws_iam_role.save-file-info.arn
  lambda_handler = "com.example.SaveFileInfoHandler::handleRequest"

  lambda_runtime = "java11"
  api_execution_arn = module.tf-upskill-bucket.bucket_arn
  lambda_permission_statement_id = "AllowExecutionFromS3Bucket"
  lambda_permission_principal = "s3.amazonaws.com"
}

module "tf-get-presigned-url"{
  source = "./modules/aws-lambda"

  lambda_filename = "zips/get-presigned-url.jar"
  lambda_function_name = "tf-get-presigned-url"
  lambda_role_arn = aws_iam_role.get-presigned-url.arn
  lambda_handler = "com.example.LambdaRequestHandler::handleRequest"

  lambda_runtime = "java11"
  api_execution_arn = aws_apigatewayv2_api.tf-upskill-api.execution_arn
  lambda_permission_statement_id = "AllowExecutionFromAPIGateway"
  lambda_permission_principal = "apigateway.amazonaws.com"
}

module "tf-process-photo"{
  source = "./modules/aws-lambda"

  lambda_filename = "zips/process-photo.jar"
  lambda_function_name = "tf-process-photo"
  lambda_role_arn = aws_iam_role.process-photo.arn
  lambda_handler = "com.example.LambdaRequestHandler::handleRequest"

  lambda_runtime = "java11"
  api_execution_arn = aws_apigatewayv2_api.tf-upskill-api.execution_arn
  lambda_permission_statement_id = "AllowExecutionFromAPIGateway"
  lambda_permission_principal = "apigateway.amazonaws.com"
}

module "tf-lambda-authorizer"{
  source = "./modules/aws-lambda"

  lambda_filename = "zips/lambda-authorizer.zip"
  lambda_function_name = "tf-lambda-authorizer"
  lambda_role_arn = aws_iam_role.lambda-authorizer.arn
  lambda_handler = "index.handler"

  lambda_runtime = "nodejs14.x"
  api_execution_arn = aws_apigatewayv2_api.tf-upskill-api.execution_arn
  lambda_permission_statement_id = "AllowExecutionFromAPIGateway"
  lambda_permission_principal = "apigateway.amazonaws.com"
}
