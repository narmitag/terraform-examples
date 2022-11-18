module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name                 = "nats-test"
  cidr                 = "${var.cidr_prefix}.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["${var.cidr_prefix}.0.0/20", "${var.cidr_prefix}.16.0/20", "${var.cidr_prefix}.32.0/20"]
  public_subnets       = ["${var.cidr_prefix}.48.0/20", "${var.cidr_prefix}.64.0/20", "${var.cidr_prefix}.80.0/20"]
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
}