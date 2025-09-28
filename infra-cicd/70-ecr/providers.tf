terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66.0"
    }
  }

  backend "s3" {
    bucket         = "infracicd-dev-s3"
    key            = "k8-ecr-dev"
    region         = "us-east-1"
    dynamodb_table = "infra-dev-locking"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
