##################################################
# DYNAMODB TABLE

resource "aws_dynamodb_table" "tradess" {

  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "userId"
  range_key = "tradeId"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "tradeId"
    type = "S"
  }

  tags = local.common_tags

}
