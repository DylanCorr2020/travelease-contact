
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

  cors_configuration {
    allow_origins = ["*"]
    allow_headers = ["content-type"]
    allow_methods = ["POST", "OPTIONS", "GET"]
  }
}

#Sets up application stages for the API Gateway - such as "Test", "Staging", and "Production". The example configuration defines a single stage, with access logging enabled
resource "aws_apigatewayv2_stage" "lambda" {

  api_id      = aws_apigatewayv2_api.travelease_api_gateway.id
  name        = "travelease_api_gateway_stage"
  auto_deploy = true
}


#Configures the API Gateway to use your Lambda function.
resource "aws_apigatewayv2_integration" "travelease_api_lambda_integration" {

  api_id             = aws_apigatewayv2_api.travelease_api_gateway.id
  integration_uri    = aws_lambda_function.travel_ease_lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

##maps an HTTP request to a target, in this case the Lambda function
resource "aws_apigatewayv2_route" "travelease_api_route" {
  api_id    = aws_apigatewayv2_api.travelease_api_gateway.id
  route_key = "POST /submit"
  target    = "integrations/${aws_apigatewayv2_integration.travelease_api_lambda_integration.id}"


}


#Gives API Gateway permission to invoke your Lambda function.
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.travel_ease_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.travelease_api_gateway.execution_arn}/*/*"
}


output "travelease_api_url" {
  description = "URL of the TravelEase API Gateway"
  value       = "${aws_apigatewayv2_api.travelease_api_gateway.api_endpoint}/${aws_apigatewayv2_stage.lambda.name}"
}


// Primary S3 bucket used to store static website files (HTML, CSS, assets)
resource "aws_s3_bucket" "website_bucket" {

  bucket = "travelease-website-bucket-35353646"

}

// Enables static website hosting on the S3 bucket and defines entry/error pages
resource "aws_s3_bucket_website_configuration" "website_bucket" {

  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

}

resource "aws_s3_object" "index" {

  bucket = aws_s3_bucket.website_bucket.id
  key    = "index.html"
  source = "../frontend/index.html"
  etag   = filemd5("../frontend/index.html")

  content_type = "text/html"

}


resource "aws_s3_object" "script" {

  bucket = aws_s3_bucket.website_bucket.id
  key    = "script.js"
  source = "../frontend/script.js"
  etag   = filemd5("../frontend/script.js")

  content_type = "application/javascript"

}

// Configures public access settings to allow the bucket to be publicly readable for website hosting
resource "aws_s3_bucket_public_access_block" "bucket_access_block" {

  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

}

// Grants public read access to all objects in the bucket so the website can be accessed via the internet
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}

// Enables versioning to keep historical copies of files for recovery and rollback
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.website_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}





