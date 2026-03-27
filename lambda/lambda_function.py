# -----------------------------
# Import Required Python Libraries
# -----------------------------

# Convert between Python dictionaries and JSON
import json

# AWS SDK for Python to interact with AWS services
import boto3

# Used to generate timestamps
from datetime import datetime

# Used for email validation with regex
import re


# -----------------------------
# Initialize AWS Services
# -----------------------------

# Create DynamoDB service resource
dynamodb = boto3.resource('dynamodb' , region_name='eu-west-1')

# Reference the DynamoDB table
table = dynamodb.Table('Travel-Ease-Database')

# Create SES email client
ses = boto3.client('ses', region_name='eu-west-1')


# -----------------------------
# Lambda Entry Point
# -----------------------------
# This function is executed every time the API Gateway calls the Lambda

def lambda_handler(event, context):

    # Print the incoming request to CloudWatch logs for debugging
    print("Event received:", event)

    try:

        # Step 1: Extract data from API Gateway request
        data = parse_event(event)

        # Step 2: Validate user input
        validate_input(data)

        # Step 3: Save contact request to DynamoDB
        save_to_dynamodb(data)

        # Step 4: Send confirmation email
        send_email(data)

        # Step 5: Return success response to frontend
        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Your request has been submitted successfully!"
            })
        }

    # Catch any errors and return error response
    except Exception as e:

        print("Error occurred:", str(e))

        return {
            "statusCode": 500,
            "body": json.dumps({
                "error": str(e)
            })
        }


# -----------------------------
# Parse API Gateway Event
# -----------------------------
# API Gateway sends the request body as a string.
# This function converts it into a Python dictionary.

def parse_event(event):

    # Check if the request contains a body
    body = event.get("body")

    if body:
        # Convert JSON string to Python dictionary
        data = json.loads(body)
    else:
        # Used when testing directly in Lambda console
        data = event

    return data


# -----------------------------
# Validate User Input
# -----------------------------
# This function checks that required fields exist
# and that the email address is properly formatted.

def validate_input(data):

    first_name = data.get("first_name")
    email = data.get("email")

    # Simple email regex pattern
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'

    # Check first name exists
    if not first_name:
        raise ValueError("First name is required")

    # Check email exists
    if not email:
        raise ValueError("Email is required")

    # Validate email format
    if not re.match(pattern, email):
        raise ValueError("Invalid email format")


# -----------------------------
# Save Data to DynamoDB
# -----------------------------
# Stores the form submission in the Travel_Ease_Database table

def save_to_dynamodb(data):

    table.put_item(
        Item={
            # Unique ID based on timestamp
            "id": str(int(datetime.utcnow().timestamp() * 1000)),

            # User data from form
            "first_name": data.get("first_name"),
            "email": data.get("email"),
            "message" : data.get("message"),

            # Record creation timestamp
            "createdAt": datetime.utcnow().isoformat()
        }
    )


# -----------------------------
# Send Email with Amazon SES
# -----------------------------
# Sends notification email when a user submits the form

def send_email(data):

    first_name = data.get("first_name")
    email = data.get("email")
    message = data.get("message")

    # Dynamic email message
    user_message = f"""
Hello {first_name},

Thank you for contacting TravelEase.

We have received your request and will get back to you shortly.

Best regards,
TravelEase Team
"""

    ses.send_email(

        # Verified sender email
        Source="travelease80@gmail.com",

        # Destination email (business inbox)
        Destination={
            "ToAddresses": [
                email
            ]
        },

        Message={

            "Subject": {
                "Data": "TravelEase Contact Request",
                "Charset": "UTF-8"
            },

            "Body": {
                "Text": {
                    "Data": user_message,
                    "Charset": "UTF-8"
                }
            }
        }
    )
    
    # -----------------------------
    # Email to BUSINESS (notification)
    # -----------------------------

    business_message = f"""
New contact form submission

Name: {first_name}
Email: {email}
Message: {message}

Please follow up with this customer.
"""

    ses.send_email(
        Source="travelease80@gmail.com",
        Destination={
            "ToAddresses": ["travelease80@gmail.com"]
        },
        Message={
            "Subject": {
                "Data": "New TravelEase Contact Request",
                "Charset": "UTF-8"
            },
            "Body": {
                "Text": {
                    "Data": business_message,
                    "Charset": "UTF-8"
                }
            }
        }
    )