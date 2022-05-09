resource "aws_cognito_user_pool" "tf-upskill-cognito-user-pool" {
  name = "${var.app-prefix}upskill-pool"
}

resource "aws_cognito_user" "tf-cognito-user" {
  user_pool_id = aws_cognito_user_pool.tf-upskill-cognito-user-pool.id
  username     = "konradstach"

  attributes = {
    email          = var.email_address
    email_verified = true
  }
}

resource "aws_cognito_user_pool_client" "tf-cognito-user-pool-client" {
  name                                 = "${var.app-prefix}cognito-user-pool-client"
  user_pool_id                         = aws_cognito_user_pool.tf-upskill-cognito-user-pool.id
  callback_urls                        = ["http://localhost:3000"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_scopes                 = ["phone", "email", "openid", "aws.cognito.signin.user.admin", "profile"]
  supported_identity_providers         = ["COGNITO"]

  access_token_validity = 8
}

resource "aws_cognito_user_pool_domain" "tf-upskill-user-pool-domain" {
  domain       = "${var.app-prefix}upskill-user-pool-domain"
  user_pool_id = aws_cognito_user_pool.tf-upskill-cognito-user-pool.id
}
