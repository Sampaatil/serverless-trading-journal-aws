##################################################
# PACKAGE LAMBDAS

data "archive_file" "add_trade" {

  type = "zip"

  source_dir = "../backend/addTrade"

  output_path = "../backend/addTrade.zip"

}

data "archive_file" "get_trade" {

  type = "zip"

  source_dir = "../backend/getTrade"

  output_path = "../backend/getTrade.zip"

}

data "archive_file" "update_trade" {

  type = "zip"

  source_dir = "../backend/updateTrade"

  output_path = "../backend/updateTrade.zip"

}

data "archive_file" "delete_trade" {

  type = "zip"

  source_dir = "../backend/deleteTrade"

  output_path = "../backend/deleteTrade.zip"

}

##################################################
# LAMBDA FUNCTIONS
##################################################

resource "aws_lambda_function" "add_trade" {

  function_name = "${var.project_name}-addTrade"

  filename = data.archive_file.add_trade.output_path

  source_code_hash = data.archive_file.add_trade.output_base64sha256

  runtime = "nodejs22.x"

  handler = "index.handler"

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.tradess.name
    }
  }

}

resource "aws_lambda_function" "get_trade" {

  function_name = "${var.project_name}-getTrades"

  filename = data.archive_file.get_trade.output_path

  source_code_hash = data.archive_file.get_trade.output_base64sha256

  runtime = "nodejs22.x"

  handler = "index.handler"

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.tradess.name
    }
  }

}

resource "aws_lambda_function" "update_trade" {

  function_name = "${var.project_name}-updateTrade"

  filename = data.archive_file.update_trade.output_path

  source_code_hash = data.archive_file.update_trade.output_base64sha256

  runtime = "nodejs22.x"

  handler = "index.handler"

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.tradess.name
    }
  }

}

resource "aws_lambda_function" "delete_trade" {

  function_name = "${var.project_name}-deleteTrade"

  filename = data.archive_file.delete_trade.output_path

  source_code_hash = data.archive_file.delete_trade.output_base64sha256

  runtime = "nodejs22.x"

  handler = "index.handler"

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.tradess.name
    }
  }

}