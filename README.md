# Travelease Contact System

A serverless contact management system built with AWS and Terraform to replace unreliable `mailto` links with a scalable, production-ready solution.

---

## 📖 Learn More

For a full breakdown of the architecture, challenges, and decisions, check out the Medium post:  
👉 [Read the Case Study](https://medium.com/p/0b06a13d5551?postPublishedType=initial)

🎥 Watch the walkthrough:  
👉 [Video Demo](https://www.loom.com/share/e622e5ba2dcf436ba210c0d8c3e42812)

---

## 🚀 Tech Stack

- **Frontend:** HTML, CSS, JavaScript
- **Backend:** AWS Lambda, API Gateway
- **Database:** DynamoDB
- **Email:** Amazon SES
- **Infrastructure:** Terraform

---

## 🏗️ Architecture

## <img width="100%" height="75%" alt="Image" src="https://github.com/user-attachments/assets/6a5f4a54-8338-4182-8e06-2ad7072c3a7c" />

## ✨ Features

- Validated contact form (client + server-side)
- Serverless API handling
- Email notifications (user + business)
- Persistent data storage
- Error handling and logging

---

## 📁 Project Structure

```
├── frontend/ # Static website (HTML, CSS, JS)
├── lambda/ # Lambda functions (Python)
├── infrastructure/ # Terraform configuration
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf
└── README.md

```

## 🛠️ Testing & CI/CD

This project includes unit tests written using pytest to validate core functionality such as input validation and request parsing.

Tests are automatically executed using GitHub Actions on each push, ensuring code reliability and preventing regressions as part of a CI/CD pipeline.

### 1. Clone the repository

```bash
git clone https://github.com/DylanCorr2020/Identity-Access-Management-Terraform.git
cd Identity-Access-Management-Terraform
```

### 2. Initialize Terraform

```bash
     terraform init
```

### 2. Review and apply changes

```bash
     terraform plan
     terrafrom apply
```

## 🔮Conclusion

This project demonstrates how to design and deploy a scalable serverless system using AWS services and Infrastructure as Code. It highlights the importance of reliability, automation, and clean system design in real-world applications.
