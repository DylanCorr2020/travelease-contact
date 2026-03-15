
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

// Create custom policy for Lambda 
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


// Create Lambda Function 
resource "aws_lambda_function" "travel_ease_lambda" {

  function_name = "travel_ease_lambda"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.14"
  role          = aws_iam_role.travelease_role_lambda.arn
  filename      = "lambda.zip"

   #Terraform to detect changes when the zip updates
  source_code_hash = filebase64sha256("lambda.zip")
}







