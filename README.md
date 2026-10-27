# Containerized Application Deployment - Infrastructure Repository

# Project Status

✅ Application CI/CD Completed

✅ Infrastructure CI/CD Completed

✅ Docker Image Versioning

✅ Terraform Remote Backend

✅ Launch Template Versioning

✅ ASG Instance Refresh

✅ Rollback Strategy Tested

🚧 Next Phase: Amazon ECS

## Overview

This repository provisions and manages AWS infrastructure using Terraform.

Infrastructure is deployed using Jenkins-driven CI/CD pipelines and reusable Terraform modules.

---

## Architecture

```text
GitHub
   |
Webhook
   |
Jenkins
   |
Terraform
   |
AWS
```

## AWS Architecture

```text
Users
   |
Application Load Balancer
   |
Target Group
   |
Auto Scaling Group
   |
EC2 Instances
   |
Docker Containers
```

## Repository Structure

```text
.
├── Terraform 
    ├── alb.tf
    ├── asg.tf
    ├── main.tf
    ├── sg.tf
    ├── vpc.tf
├── .gitignore
├── Jenkinsfile
└── README.md
```
---

## Module Strategy

Infrastructure uses reusable Terraform modules stored in external GitHub repositories.

Example:

module "vpc" {
  source = "git::https://github.com/<repo>.git//modules?ref=1.0"
}

Benefits:

- Reusability
- Versioning
- Standardization

---

## Infrastructure Provisioned

### Networking

- VPC
- Public Subnets
- Private Subnets
- Routing
- Internet Access

### Load Balancing

- Application Load Balancer
- Target Groups
- Health Checks

### Compute

- Launch Templates
- Auto Scaling Groups
- EC2 Instances

### Container Runtime

- Docker installed using User Data
- Automatic image pull
- Automatic container startup

---

## Deployment Strategy

Terraform variable controls deployed version.

Example:

docker_image_version = "5"

User Data:

docker pull r0hit45/containerized-app:${docker_image_version}

This allows controlled upgrades and rollbacks.

---

## Versioned Deployments

Deployment process:

```text
Build Image
↓
Push Docker Hub
↓
Update Image Version
↓
Terraform Apply
↓
Launch Template Version Update
↓
ASG Instance Refresh
↓
New Version Active
```
---

## Rollback Strategy

If a deployment fails:

docker_image_version = "6"

can be reverted to:

docker_image_version = "5"
```text
Terraform Apply
↓
ASG Refresh
↓
Rollback Complete
```
---

## Technologies Used

- AWS
- Terraform
- Jenkins
- GitHub
- Docker
- Docker Hub

---

## Key Learning Areas

- Infrastructure as Code
- Terraform Modules
- Remote State
- Launch Template Versioning
- Auto Scaling Groups
- Load Balancing
- Versioned Deployments
- Rollback Strategy
- CI/CD

