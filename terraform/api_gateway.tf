#############################################################
# REST API

resource "aws_api_gateway_rest_api" "trading_api" {

  name = "${var.project_name}-api"

  description = "Trading Journal REST API"

  endpoint_configuration {

    types = ["REGIONAL"]

  }

}

#############################################################
# COGNITO AUTHORIZER

resource "aws_api_gateway_authorizer" "cognito" {

  name = "TradingJournalAuthorizer"

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  type = "COGNITO_USER_POOLS"

  provider_arns = [

    aws_cognito_user_pool.trading_users.arn

  ]

  identity_source = "method.request.header.Authorization"

}

#############################################################
# /addTrade

resource "aws_api_gateway_resource" "add_trade" {

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  parent_id = aws_api_gateway_rest_api.trading_api.root_resource_id

  path_part = "addTrade"

}

resource "aws_api_gateway_method" "add_trade" {

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  resource_id = aws_api_gateway_resource.add_trade.id

  http_method = "POST"

  authorization = "COGNITO_USER_POOLS"

  authorizer_id = aws_api_gateway_authorizer.cognito.id

}

#############################################################
# /getTrades
resource "aws_api_gateway_resource" "get_trade" {

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  parent_id = aws_api_gateway_rest_api.trading_api.root_resource_id

  path_part = "getTrades"

}
resource "aws_api_gateway_method" "get_trade" {

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  resource_id = aws_api_gateway_resource.get_trade.id

  http_method = "GET"

  authorization = "COGNITO_USER_POOLS"

  authorizer_id = aws_api_gateway_authorizer.cognito.id

  request_parameters = {
    "method.request.querystring.month" = false
  }

}

#############################################################
# /updateTrade

resource "aws_api_gateway_resource" "update_trade" {

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  parent_id = aws_api_gateway_rest_api.trading_api.root_resource_id

  path_part = "updateTrade"

}

resource "aws_api_gateway_method" "update_trade" {

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  resource_id = aws_api_gateway_resource.update_trade.id

  http_method = "PUT"

  authorization = "COGNITO_USER_POOLS"

  authorizer_id = aws_api_gateway_authorizer.cognito.id

}

#############################################################
# /deleteTrade

resource "aws_api_gateway_resource" "delete_trade" {

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  parent_id = aws_api_gateway_rest_api.trading_api.root_resource_id

  path_part = "deleteTrade"

}

resource "aws_api_gateway_method" "delete_trade" {

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  resource_id = aws_api_gateway_resource.delete_trade.id

  http_method = "DELETE"

  authorization = "COGNITO_USER_POOLS"

  authorizer_id = aws_api_gateway_authorizer.cognito.id

}

#############################################################
# ADD TRADE INTEGRATION

resource "aws_api_gateway_integration" "add_trade" {

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  resource_id = aws_api_gateway_resource.add_trade.id

  http_method = aws_api_gateway_method.add_trade.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"

  uri = aws_lambda_function.add_trade.invoke_arn

}

#############################################################
# GET TRADES INTEGRATION

resource "aws_api_gateway_integration" "get_trade" {

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  resource_id = aws_api_gateway_resource.get_trade.id

  http_method = aws_api_gateway_method.get_trade.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"

  uri = aws_lambda_function.get_trade.invoke_arn

}

#############################################################
# UPDATE TRADE INTEGRATION

resource "aws_api_gateway_integration" "update_trade" {

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  resource_id = aws_api_gateway_resource.update_trade.id

  http_method = aws_api_gateway_method.update_trade.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"

  uri = aws_lambda_function.update_trade.invoke_arn

}

#############################################################
# DELETE TRADE INTEGRATION

resource "aws_api_gateway_integration" "delete_trade" {

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  resource_id = aws_api_gateway_resource.delete_trade.id

  http_method = aws_api_gateway_method.delete_trade.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"

  uri = aws_lambda_function.delete_trade.invoke_arn

}

#############################################################
# LAMBDA PERMISSION - ADD TRADE

resource "aws_lambda_permission" "add_trade" {

  statement_id = "AllowAddTrade"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.add_trade.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.trading_api.execution_arn}/*/POST/addTrade"

}

#############################################################
# LAMBDA PERMISSION - GET TRADES

resource "aws_lambda_permission" "get_trade" {

  statement_id = "AllowgetTrades"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.get_trade.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.trading_api.execution_arn}/*/GET/getTrades"

}

#############################################################
# LAMBDA PERMISSION - UPDATE TRADE

resource "aws_lambda_permission" "update_trade" {

  statement_id = "AllowUpdateTrade"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.update_trade.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.trading_api.execution_arn}/*/PUT/updateTrade"

}

#############################################################
# LAMBDA PERMISSION - DELETE TRADE

resource "aws_lambda_permission" "delete_trade" {

  statement_id = "AllowDeleteTrade"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.delete_trade.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.trading_api.execution_arn}/*/DELETE/deleteTrade"

}

#############################################################
resource "aws_api_gateway_deployment" "deploy" {

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  depends_on = [

    aws_api_gateway_method.add_trade,
    aws_api_gateway_method.get_trade,
    aws_api_gateway_method.update_trade,
    aws_api_gateway_method.delete_trade,

    aws_api_gateway_integration.add_trade,
    aws_api_gateway_integration.get_trade,
    aws_api_gateway_integration.update_trade,
    aws_api_gateway_integration.delete_trade,

    aws_api_gateway_authorizer.cognito,

    module.cors_add_trade,
    module.cors_get_trade,
    module.cors_update_trade,
    module.cors_delete_trade,

    aws_api_gateway_gateway_response.unauthorized,
    aws_api_gateway_gateway_response.access_denied

  ]

  triggers = {
    redeployment = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}

#############################################################
# PROD STAGE

module "cors_get_trade" {
  source      = "./modules/cors"
  rest_api_id = aws_api_gateway_rest_api.trading_api.id
  resource_id = aws_api_gateway_resource.get_trade.id
}

module "cors_add_trade" {
  source      = "./modules/cors"
  rest_api_id = aws_api_gateway_rest_api.trading_api.id
  resource_id = aws_api_gateway_resource.add_trade.id
}

module "cors_update_trade" {
  source      = "./modules/cors"
  rest_api_id = aws_api_gateway_rest_api.trading_api.id
  resource_id = aws_api_gateway_resource.update_trade.id
}

module "cors_delete_trade" {
  source      = "./modules/cors"
  rest_api_id = aws_api_gateway_rest_api.trading_api.id
  resource_id = aws_api_gateway_resource.delete_trade.id
}


resource "aws_api_gateway_stage" "prod" {

  deployment_id = aws_api_gateway_deployment.deploy.id

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  stage_name = "Prod"

  access_log_settings {

    destination_arn = aws_cloudwatch_log_group.api_gateway_logs.arn

    format = jsonencode({

      requestId = "$context.requestId"

      ip = "$context.identity.sourceIp"

      caller = "$context.identity.caller"

      user = "$context.identity.user"

      requestTime = "$context.requestTime"

      httpMethod = "$context.httpMethod"

      resourcePath = "$context.resourcePath"

      status = "$context.status"

      protocol = "$context.protocol"

      responseLength = "$context.responseLength"

      authorizer = "$context.authorizer.claims.sub"

    })

  }

}

resource "aws_api_gateway_gateway_response" "unauthorized" {

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  response_type = "UNAUTHORIZED"

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'*'"
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'*'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}

resource "aws_api_gateway_gateway_response" "access_denied" {

  rest_api_id = aws_api_gateway_rest_api.trading_api.id

  response_type = "ACCESS_DENIED"

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"  = "'*'"
    "gatewayresponse.header.Access-Control-Allow-Headers" = "'*'"
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
  }
}