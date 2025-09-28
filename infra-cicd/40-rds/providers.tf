terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.85.0"
    }
  }
  backend "s3" {
    bucket         = "infracicd-dev-s3"
    key            = "rds-dev"
    region         = "us-east-1"
    dynamodb_table = "infra-dev-locking"
  }
}

provider "aws" {
  region = "us-east-1"
}