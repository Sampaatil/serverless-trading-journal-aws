##################################################
# DYNAMODB

output "dynamodb_table_name" {

  value = aws_dynamodb_table.tradess.name

}

##################################################
# COGNITO

output "user_pool_id" {

  value = aws_cognito_user_pool.trading_users.id

}

output "user_pool_client_id" {

  value = aws_cognito_user_pool_client.web_client.id

}

##################################################
# S3 WEBSITE

output "website_bucket_name" {

  value = aws_s3_bucket.website.bucket

}

output "website_endpoint" {

  value = aws_s3_bucket_website_configuration.website.website_endpoint

}

output "website_url" {

  value = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"

}

##################################################
# API GATEWAY

output "api_gateway_id" {

  value = aws_api_gateway_rest_api.trading_api.id

}

output "api_url" {

  value = aws_api_gateway_stage.prod.invoke_url

}

output "cognito_client_id" {
  value = aws_cognito_user_pool_client.web_client.id
}
