terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.29"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}