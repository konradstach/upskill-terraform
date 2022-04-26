resource "aws_lambda_function" "tf-get-user-photos" {
  filename      = "zips/get-user-photos.jar"
  function_name = "tf-get-user-photos"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "com.example.LambdaRequestHandler::handleRequest"

  source_code_hash = filebase64sha256("zips/get-user-photos.jar")
  runtime          = "java11"
  timeout          = 60
  memory_size      = 512
}

resource "aws_lambda_function" "tf-save-file-info" {
  filename      = "zips/save-file-info.jar"
  function_name = "tf-save-file-info"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "com.example.SaveFileInfoHandler::handleRequest"

  source_code_hash = filebase64sha256("zips/save-file-info.jar")
  runtime          = "java11"
  timeout          = 120
  memory_size      = 512
}

resource "aws_lambda_function" "tf-get-presigned-url" {
  filename      = "zips/get-presigned-url.jar"
  function_name = "tf-get-presigned-url"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "com.example.LambdaRequestHandler::handleRequest"

  source_code_hash = filebase64sha256("zips/get-presigned-url.jar")
  runtime          = "java11"
  timeout          = 30
  memory_size      = 512
}

resource "aws_lambda_function" "tf-lambda-authorizer" {
  filename      = "zips/lambda-authorizer.zip"
  function_name = "tf-lambda-authorizer"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"

  source_code_hash = filebase64sha256("zips/lambda-authorizer.zip")
  runtime          = "nodejs14.x"
  timeout          = 60
  memory_size      = 512
}

resource "aws_lambda_function" "tf-process-photo" {
  filename      = "zips/process-photo.jar"
  function_name = "tf-process-photo"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "com.example.LambdaRequestHandler::handleRequest"

  source_code_hash = filebase64sha256("zips/process-photo.jar")
  runtime          = "java11"
  timeout          = 120
  memory_size      = 512
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf-save-file-info.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.tf-upskill-bucket.arn
}

resource "aws_lambda_permission" "tf-presigned-url" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf-get-presigned-url.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.tf-upskill-api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "tf-lambda-authorizer" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf-lambda-authorizer.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.tf-upskill-api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "tf-get-user-photos" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf-get-user-photos.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.tf-upskill-api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "tf-process-photo" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf-process-photo.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.tf-upskill-api.execution_arn}/*/*"
}