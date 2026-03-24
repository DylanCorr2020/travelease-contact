# Travelease Contact System

A serverless contact management system built with AWS and Terraform to replace unreliable `mailto` links with a scalable, production-ready solution.

[📖 Read the Full Case Study](https://medium.com/) • [🎥 Watch the Demo](https://)

---

## 🚀 Tech Stack

- **Frontend:** HTML, CSS, JavaScript  
- **Backend:** AWS Lambda, API Gateway  
- **Database:** DynamoDB  
- **Email:** Amazon SES  
- **Infrastructure:** Terraform  

---

## 🏗️ Architecture

S3 (Frontend) → API Gateway → Lambda → DynamoDB  
                                      ↓  
                                     SES  

---

## ✨ Features

- Validated contact form (client + server-side)  
- Serverless API handling  
- Email notifications (user + business)  
- Persistent data storage  
- Error handling and logging  

---

## ⚙️ Setup

```bash
terraform init
terraform apply