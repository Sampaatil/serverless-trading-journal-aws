##################################################
# IAM ROLE FOR LAMBDA

resource "aws_iam_role" "lambda_role" {

  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "lambda.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

  tags = local.common_tags

}

##################################################
# CLOUDWATCH LOGS POLICY

resource "aws_iam_role_policy_attachment" "logs" {

  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}

##################################################
# DYNAMODB ACCESS POLICY

resource "aws_iam_policy" "dynamodb_policy" {

  name = "${var.project_name}-dynamodb-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"

        ]

        Resource = aws_dynamodb_table.tradess.arn

      }

    ]

  })

}

##################################################
# ATTACH DYNAMODB POLICY

resource "aws_iam_role_policy_attachment" "dynamodb" {

  role = aws_iam_role.lambda_role.name

  policy_arn = aws_iam_policy.dynamodb_policy.arn

}