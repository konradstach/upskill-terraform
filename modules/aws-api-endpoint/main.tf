resource "aws_apigatewayv2_route" "tf-process-photo" {
  api_id = var.api_id

  route_key          = var.route_key
  target             = "integrations/${aws_apigatewayv2_integration.tf-process-photo.id}"
  authorization_type = var.route_authorization_type
  authorizer_id      = var.route_authorizer_id
}

resource "aws_apigatewayv2_integration" "tf-process-photo" {
  api_id = var.api_id

  integration_type       = var.integration_type
  integration_uri        = var.integration_uri
  integration_method     = var.integration_method
  payload_format_version = "2.0"
}