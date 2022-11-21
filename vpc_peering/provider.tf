terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = "3.42.0"
    }
  }
}
provider "aws" {
  region     = var.region
}
provider "aws" {
  region     = "us-east-1"
  alias      = "owner"
  #profile    = "sb"

}
provider "aws" {
  region     = "us-east-1"
  alias      = "accepter"
  #profile    = "sb-dev"
}