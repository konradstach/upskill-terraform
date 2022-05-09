resource "aws_apigatewayv2_api" "tf-upskill-api" {
  name          = "${var.app-prefix}upskill-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "tf-upskill-api-stage" {
  api_id      = aws_apigatewayv2_api.tf-upskill-api.id
  name        = "${var.app-prefix}upskill-api-stage"
  auto_deploy = "true"
}

resource "aws_apigatewayv2_authorizer" "tf-jwt-authorizer" {
  api_id           = aws_apigatewayv2_api.tf-upskill-api.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "${var.app-prefix}jwt-authorizer"

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.tf-cognito-user-pool-client.id]
    issuer   = "https://${aws_cognito_user_pool.tf-upskill-cognito-user-pool.endpoint}"
  }
}

resource "aws_apigatewayv2_authorizer" "tf-lambda-authorizer" {
  api_id                            = aws_apigatewayv2_api.tf-upskill-api.id
  authorizer_type                   = "REQUEST"
  identity_sources                  = ["$request.header.Authorization"]
  name                              = "tf-get-user-photos-authorizer"
  authorizer_uri                    = module.tf-lambda-authorizer.invoke_arn
  authorizer_payload_format_version = "2.0"
  enable_simple_responses           = "true"
}

module "tf-get-presigned-url-endpoint"{
  source = "./modules/aws-api-endpoint"

  api_id = aws_apigatewayv2_api.tf-upskill-api.id
  route_key = "GET /presigned-url"
  route_authorization_type = "JWT"
  route_authorizer_id = aws_apigatewayv2_authorizer.tf-jwt-authorizer.id
  integration_uri = module.tf-process-photo.invoke_arn
}

module "tf-get-photos-endpoint"{
  source = "./modules/aws-api-endpoint"

  api_id = aws_apigatewayv2_api.tf-upskill-api.id
  route_key = "GET /photos"
  route_authorization_type = "CUSTOM"
  route_authorizer_id = aws_apigatewayv2_authorizer.tf-lambda-authorizer.id
  integration_uri = module.tf-get-user-photos.invoke_arn
}

module "tf-process-photo-endpoint"{
  source = "./modules/aws-api-endpoint"

  api_id = aws_apigatewayv2_api.tf-upskill-api.id
  route_key = "POST /photos/monochrome"
  route_authorization_type = "CUSTOM"
  route_authorizer_id = aws_apigatewayv2_authorizer.tf-lambda-authorizer.id
  integration_uri = module.tf-process-photo.invoke_arn
}

