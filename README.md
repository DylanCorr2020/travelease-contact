# Travelease Contact System

## Overview

This project is a serverless contact management system designed to replace unreliable `mailto` links with a scalable and structured solution. It enables businesses to reliably capture, store, and respond to customer inquiries.

The system is built using AWS services and Infrastructure as Code principles, providing a production-style architecture with minimal operational overhead.

---

## Problem

Traditional `mailto`-based contact forms create several issues:

### Customer Issues
- No confirmation that messages are received
- Emails may be lost or marked as spam
- No way to track or follow up

### Business Issues
- Manual and inconsistent data handling
- No structure or prioritization
- No visibility into response times or performance

---

## Solution

This project introduces a modern contact system where:

- Users submit inquiries through a validated web form
- Requests are processed via a serverless backend
- Data is stored securely in a database
- Confirmation emails are sent automatically
- Businesses receive inquiries instantly

---

## Architecture

The system follows a serverless architecture:

1. Frontend hosted on S3  
2. API Gateway handles incoming HTTP requests  
3. AWS Lambda processes and validates data  
4. DynamoDB stores inquiries  
5. Amazon SES sends email notifications  
6. CloudWatch handles logging and monitoring  

---

## Tech Stack

- **Frontend:** HTML, CSS, JavaScript  
- **Backend:** AWS Lambda, API Gateway  
- **Database:** DynamoDB (NoSQL)  
- **Email Service:** Amazon SES  
- **Infrastructure:** Terraform (Infrastructure as Code)  
- **Monitoring:** CloudWatch  
- **Tools:** GitHub, Postman, PowerShell, VS Code  

---

## Core Features

- **Validated Contact Form**  
  Client and server-side validation ensures clean input data.

- **Serverless API**  
  Scalable request handling using API Gateway and Lambda.

- **Email Notifications**  
  Automated confirmations and business notifications via SES.

- **Data Persistence**  
  Reliable storage of all inquiries in DynamoDB.

- **Error Handling & Logging**  
  Structured logging and error management using CloudWatch.

---

## Challenges & Solutions

- **AWS SDK Compatibility**  
  Node.js runtime lacked built-in AWS SDK. Switched to Python (Boto3) for native support.

- **CORS Issues**  
  Requests failed due to `origin: null` when opening HTML directly. Resolved by using a local development server.

- **Lambda Deployment Errors**  
  Incorrect zip structure caused module import failures. Fixed by restructuring deployment package.

- **API Gateway Configuration**  
  Encountered 404 errors due to missing stage deployment. Resolved by enabling auto-deploy and correcting endpoint.

- **S3 Permissions**  
  Access denied errors fixed by configuring public access settings in Terraform.

---

## What I Learned

- How to design and implement a serverless architecture  
- Integrating AWS services (Lambda, API Gateway, DynamoDB, SES)  
- Debugging real-world issues like CORS and deployment errors  
- Using Terraform for consistent infrastructure provisioning  

---

## Future Improvements

- Admin dashboard for managing inquiries  
- Authentication and user management  
- Analytics for response times and conversions  
- Enhanced validation and spam protection  

---

## Getting Started

### Prerequisites

- AWS Account  
- Terraform installed  
- Node.js or Python environment  

### Setup

```bash
terraform init
terraform apply