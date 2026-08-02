Project Overview

Architecture

AWS Services

Prerequisites

Folder Structure

Deployment Guide

Terraform Commands

Future Improvements

                     Route53
                        │
                 ACM SSL Certificate
                        │
              Application Load Balancer
                        │
              ECS Cluster (EC2 Launch Type)
          ┌─────────────┴─────────────┐
          │                           │
    Employee Service             Admin Service
          │                           │
          └──────────API Gateway──────┘
                        │
         ┌──────────────┼──────────────┐
         │              │              │
      Cognito        Lambda        CloudWatch
         │              │
         │         Audit Logs
         │              │
      DynamoDB <────────┘
         │
         │
        RDS PostgreSQL
         │
         │
     Employee Records

S3 Buckets

• Employee Documents
• Profile Images
• Terraform State
• Backups

GitHub

↓

CodePipeline

↓

Terraform Apply

↓

Docker Build

↓

ECR

↓

Deploy ECS