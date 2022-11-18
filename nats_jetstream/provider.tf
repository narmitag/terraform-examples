terraform {

  #required_version = "1.2.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
  }
}

provider "aws" {
  region = var.region
}