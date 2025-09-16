terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.85.0"
    }
  }
  backend "s3" {
    bucket         = "remotestate-s301-dev"
    key            = "expense-sg-dev"
    region         = "us-east-1"
    dynamodb_table = "expense-locking-dev"
  }
}

provider "aws" {
  region = "us-east-1"
}