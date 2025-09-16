terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
       version = "5.5.0"
    }
  }

  backend "s3" {
    bucket = "ci-cd-deploy-s3bucket"
    key    = " cicd "
    region = "us-east-1"
    dynamodb_table = "cicd-locking"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}