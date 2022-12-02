module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.66.0"

  name                 = "eks-vpc-${var.environment_name}"
  cidr                 = "10.0.0.0/16"
  azs                  = ["${var.region}b"]
  private_subnets      = ["10.0.1.0/24"]
  public_subnets       = ["10.0.4.0/24"]
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  public_subnet_tags = {
 
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
 
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

