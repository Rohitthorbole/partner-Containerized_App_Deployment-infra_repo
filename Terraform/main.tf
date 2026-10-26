terraform {
  required_providers {
    aws = {
      version = "~>5.0.0"
      source  = "hashicorp/aws"
    }
  }
  required_version = ">= 1.5.0"
  backend "s3" {
    bucket         = "partner-containerized-app-deployment-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}

provider "aws" {
  region  = "us-east-1"
}