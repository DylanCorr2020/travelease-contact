
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
  runtime       = "python3.11"
  role          = aws_iam_role.travelease_role_lambda.arn
  filename      = "lambda.zip"

  #Terraform to detect changes when the zip updates
  source_code_hash = filebase64sha256("lambda.zip")
}


#Create HTTP API Gateway 

#Name for the API Gateway and sets its protocol to HTTP.
resource "aws_apigatewayv2_api" "travelease_api_gateway" {
  name          = "travelease_api_gateway"
  protocol_type = "HTTP"
}

#Sets up application stages for the API Gateway - such as "Test", "Staging", and "Production". The example configuration defines a single stage, with access logging enabled
resource "aws_apigatewayv2_stage" "lambda" {

  api_id = aws_apigatewayv2_api.travelease_api_gateway.id
  name   = "travelease_api_gateway_stage"
}


#Configures the API Gateway to use your Lambda function.
resource "aws_apigatewayv2_integration" "travelease_api_lambda_integration" {
   
   api_id = aws_apigatewayv2_api.travelease_api_gateway.id
   integration_uri = aws_lambda_function.travel_ease_lambda.invoke_arn
   integration_type = "AWS_PROXY"
   integration_method = "POST"
}

 ##maps an HTTP request to a target, in this case the Lambda function
resource "aws_apigatewayv2_route" "travelease_api_route" {
    api_id = aws_apigatewayv2_api.travelease_api_gateway.id
    route_key = "POST /submit"
    target = "integrations/${aws_apigatewayv2_integration.travelease_api_lambda_integration.id}"

  
}


#Gives API Gateway permission to invoke your Lambda function.
resource "aws_lambda_permission" "api_gw" {
    statement_id = "AllowExecutionFromAPIGateway"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.travel_ease_lambda.function_name
    principal     = "apigateway.amazonaws.com"
    source_arn    = "${aws_apigatewayv2_api.travelease_api_gateway.execution_arn}/*/*"
}


output "travelease_api_url" {
  description = "URL of the TravelEase API Gateway"
  value       = "${aws_apigatewayv2_api.travelease_api_gateway.api_endpoint}/${aws_apigatewayv2_stage.lambda.name}"
}



