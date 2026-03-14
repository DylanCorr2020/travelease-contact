
//Create Dynamodb table 
resource "aws_dynamodb_table" "travel-ease-database" {

  name         = "Travel-Ease-Database"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}


//Create IAM Role for Lambda

resource "aws_iam_role" "travelease_role_lambda" {

    name = "travelease_role_lambda"

    assume_role_policy = jsonencode({
      Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
    })
  
}

resource "aws_iam_role_policy" "my_policy" {
  name = "my_custom_policy"
  role = aws_iam_role.travelease_role_lambda.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
         "dynamodb:PutItem",
         "ses:SendEmail",
				 "ses:SendRawEmail",
         "logs:CreateLogGroup",
         "logs:CreateLogStream",
         "logs:PutLogEvents",

      ]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}




