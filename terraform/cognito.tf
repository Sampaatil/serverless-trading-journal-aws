##################################################
# USER POOL

resource "aws_cognito_user_pool" "trading_users" {

  name = var.cognito_user_pool_name

  username_attributes = []

  password_policy {

    minimum_length                   = 8
    require_lowercase                = true
    require_uppercase                = true
    require_numbers                  = true
    require_symbols                  = false
    temporary_password_validity_days = 7

  }

  tags = local.common_tags

}

##################################################
# USER POOL CLIENT

resource "aws_cognito_user_pool_client" "web_client" {

  name = var.cognito_client_name

  user_pool_id = aws_cognito_user_pool.trading_users.id

  generate_secret = false

  explicit_auth_flows = [

    "ALLOW_USER_PASSWORD_AUTH",

    "ALLOW_REFRESH_TOKEN_AUTH",

    "ALLOW_USER_SRP_AUTH"

  ]

  prevent_user_existence_errors = "ENABLED"

  supported_identity_providers = [

    "COGNITO"

  ]

}

##################################################
# OPTIONAL DOMAIN
##################################################

# Uncomment if later you want a Hosted UI.
#
# resource "aws_cognito_user_pool_domain" "domain" {
#
#   domain       = "${var.project_name}-auth"
#   user_pool_id = aws_cognito_user_pool.trading_users.id
#
# }