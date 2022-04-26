resource "aws_apigatewayv2_api" "tf-upskill-api" {
  name          = "tf-upskill-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "tf-upskill-api-stage" {
  api_id      = aws_apigatewayv2_api.tf-upskill-api.id
  name        = "upskill-api-stage"
  auto_deploy = "true"
}

resource "aws_apigatewayv2_route" "tf-get-presigned-url" {
  api_id = aws_apigatewayv2_api.tf-upskill-api.id

  route_key          = "GET /presigned-url"
  target             = "integrations/${aws_apigatewayv2_integration.tf-get-presigned-url.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.tf-presigned-url-authorizer.id
}

resource "aws_apigatewayv2_integration" "tf-get-presigned-url" {
  api_id = aws_apigatewayv2_api.tf-upskill-api.id

  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.tf-get-presigned-url.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_authorizer" "tf-presigned-url-authorizer" {
  api_id           = aws_apigatewayv2_api.tf-upskill-api.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "tf-presigned-url-authorizer"

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.tf-cognito-user-pool-client.id]
    issuer   = "https://${aws_cognito_user_pool.tf-upskill-cognito-user-pool.endpoint}"
  }
}

resource "aws_apigatewayv2_route" "tf-get-photos" {
  api_id = aws_apigatewayv2_api.tf-upskill-api.id

  route_key          = "GET /photos"
  target             = "integrations/${aws_apigatewayv2_integration.tf-get-photos.id}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.tf-lambda-authorizer.id
}

resource "aws_apigatewayv2_integration" "tf-get-photos" {
  api_id = aws_apigatewayv2_api.tf-upskill-api.id

  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.tf-get-user-photos.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "tf-process-photo" {
  api_id = aws_apigatewayv2_api.tf-upskill-api.id

  route_key          = "POST /photos/monochrome"
  target             = "integrations/${aws_apigatewayv2_integration.tf-process-photo.id}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.tf-lambda-authorizer.id
}

resource "aws_apigatewayv2_integration" "tf-process-photo" {
  api_id = aws_apigatewayv2_api.tf-upskill-api.id

  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.tf-process-photo.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_authorizer" "tf-lambda-authorizer" {
  api_id                            = aws_apigatewayv2_api.tf-upskill-api.id
  authorizer_type                   = "REQUEST"
  identity_sources                  = ["$request.header.Authorization"]
  name                              = "tf-get-user-photos-authorizer"
  authorizer_uri                    = aws_lambda_function.tf-lambda-authorizer.invoke_arn
  authorizer_payload_format_version = "2.0"
  enable_simple_responses           = "true"
}
