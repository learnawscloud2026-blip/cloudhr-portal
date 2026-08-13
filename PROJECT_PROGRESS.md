# CloudHR Portal - Project Progress

## Project Overview

CloudHR Portal is a production-style AWS cloud application deployed completely using Terraform Infrastructure as Code.

### Tech Stack

- Terraform
- AWS VPC
- ECS Fargate
- Application Load Balancer
- RDS MySQL
- DynamoDB
- Lambda
- API Gateway
- Cognito
- S3
- Route53
- ACM
- CodePipeline
- CloudWatch
- SNS

---

# Module Progress

| Module | Status | Verified |
|---------|--------|----------|
| VPC | ✅ Completed | ✅ AWS Console |
| Subnets | ✅ Completed | ✅ AWS Console |
| Internet Gateway | ✅ Completed | ✅ AWS Console |
| Elastic IP | ⬜ Pending | ⬜ |
| NAT Gateway | ⬜ Pending | ⬜ |
| Route Tables | ⬜ Pending | ⬜ |
| Route Associations | ⬜ Pending | ⬜ |
| Security Groups | ⬜ Pending | ⬜ |
| IAM | ⬜ Pending | ⬜ |
| S3 | ⬜ Pending | ⬜ |
| ECR | ⬜ Pending | ⬜ |
| ECS | ⬜ Pending | ⬜ |
| ALB | ⬜ Pending | ⬜ |
| RDS | ⬜ Pending | ⬜ |
| DynamoDB | ⬜ Pending | ⬜ |
| Lambda | ⬜ Pending | ⬜ |
| API Gateway | ⬜ Pending | ⬜ |
| Cognito | ⬜ Pending | ⬜ |
| CloudWatch | ⬜ Pending | ⬜ |
| SNS | ⬜ Pending | ⬜ |
| Route53 | ⬜ Pending | ⬜ |
| ACM | ⬜ Pending | ⬜ |
| CodePipeline | ⬜ Pending | ⬜ |

---

## Notes

### Sprint 1

- Created reusable VPC module.
- Implemented common tagging strategy.
- Verified VPC in AWS Console.

### Sprint 2

- Created reusable subnet module using `for_each`.
- Created six subnets.
- Verified subnet creation.

### Sprint 3

- Created Internet Gateway module.
- Attached IGW to VPC.
- Verified attachment in AWS Console.cd 

## Sprint 15 - ECS + ALB Deployment ✅

### Completed

- Created Application Load Balancer
- Created Target Group
- Configured HTTP Listener
- Attached ECS Service to Target Group
- Configured Health Check (/health)
- Fixed ECS Security Group (8000)
- Verified Healthy Target
- Successfully accessed FastAPI application through ALB DNS

### AWS Services Used

- ECS
- Fargate
- ALB
- Target Groups
- CloudWatch
- Security Groups
- IAM