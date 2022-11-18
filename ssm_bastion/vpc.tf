module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "simple-example"

  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.2.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-name"
  }
}

data "aws_availability_zones" "available" {}