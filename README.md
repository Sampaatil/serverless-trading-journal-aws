# 📈 TradeVista - Serverless Trading Journal on AWS

TradeVista is a production-ready serverless trading journal that enables traders to securely record, manage, and analyze their trades. The application is built using AWS serverless services and fully provisioned using Terraform as Infrastructure as Code (IaC).

---

## 🚀 Features

- 🔐 User Authentication using Amazon Cognito
- 📝 Create, Update, Delete and View Trades
- 📅 Monthly Trade Filtering
- 📊 Trading Analytics Dashboard
- 🎯 Trade Accuracy Calculation
- 📈 Total Pips Calculation
- 🥧 Win/Loss/Breakeven Pie Chart
- 🔒 JWT Protected REST APIs
- ☁️ Fully Serverless Architecture
- 🏗️ Infrastructure Provisioned using Terraform

---

## 🏗️ Architecture

```
                    +----------------+
                    |    Browser     |
                    +--------+-------+
                             |
                             |
                      S3 Static Website
                             |
                             |
                     API Gateway (REST)
                             |
         ---------------------------------------
         |         |         |        |
     AddTrade  GetTrades  Update  Delete
         |         |         |        |
         -------- AWS Lambda ----------
                     |
                     |
                 DynamoDB
                     |
                     |
               Amazon Cognito
            (User Authentication)
```

---

## 🛠️ Technologies Used

### Cloud

- AWS Lambda
- Amazon API Gateway
- Amazon Cognito
- Amazon DynamoDB
- Amazon S3
- AWS IAM
- Amazon CloudWatch

### Infrastructure

- Terraform

### Frontend

- HTML5
- CSS3
- JavaScript

---

## 📂 Project Structure

```
serverless-trading-journal-aws/

├── frontend/
│   ├── index.html
│   ├── script.js
│   ├── style.css
│
├── terraform/
│   ├── modules/
│   │
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── provider.tf
│
├── lambda/
│   ├── addTrade/
│   ├── getTrades/
│   ├── updateTrade/
│   └── deleteTrade/
│
└── README.md
```

---

## 🔐 Authentication Flow

1. User signs up using Amazon Cognito.
2. User logs in.
3. Cognito returns a JWT ID Token.
4. Frontend stores the token.
5. Every API request sends:

```
Authorization: Bearer <JWT_TOKEN>
```

6. API Gateway validates the token.
7. Lambda receives authenticated user information.

---

## 📊 Dashboard

The dashboard provides:

- Monthly trade history
- Total trades
- Win rate
- Total pips
- Pie chart visualization
- Trade analysis notes

---

## Infrastructure Provisioned by Terraform

Terraform automatically creates:

- Amazon Cognito User Pool
- Cognito App Client
- DynamoDB Table
- IAM Roles
- Lambda Functions
- Lambda Permissions
- API Gateway
- API Gateway Authorizer
- API Gateway CORS Configuration
- S3 Static Website
- CloudWatch Log Groups

---

## Local Deployment

Clone repository

```bash
git clone https://github.com/Sampaatil/serverless-trading-journal-aws.git
```

Move into project

```bash
cd serverless-trading-journal-aws
```

Initialize Terraform

```bash
cd terraform

terraform init
```

Review Infrastructure

```bash
terraform plan
```

Deploy

```bash
terraform apply
```

Upload frontend files to S3.

---

## API Endpoints

| Method | Endpoint | Description |
|---------|----------|-------------|
| POST | /addTrade | Create Trade |
| GET | /getTrades | Fetch Trades |
| PUT | /updateTrade | Update Trade |
| DELETE | /deleteTrade | Delete Trade |

All endpoints are protected using Amazon Cognito Authorizer.

---

## Security

- JWT Authentication
- Cognito User Pool Authorizer
- IAM Least Privilege
- CORS Configured
- User Isolation using Cognito Subject (sub)
- Serverless Architecture

---

## Challenges Solved

During development, several real-world production issues were resolved:

- API Gateway CORS configuration
- Lambda IAM permissions
- API Gateway Deployment issues
- Terraform module dependency management
---

## Future Improvements

- GitHub Actions CI/CD
- CloudFront CDN
- Trade Performance Reports
- Export Trades to CSV
- Responsive Mobile UI
- Risk/Reward Analytics
- Multi-account Support

---

## Author

**Samarjeet Patil**

DevOps & Cloud Engineer

GitHub:
https://github.com/Sampaatil

LinkedIn:
https://www.linkedin.com/in/devops-samarjeet/

Hashnode:
https://samargeet.hashnode.dev/

---

## License

MIT License
