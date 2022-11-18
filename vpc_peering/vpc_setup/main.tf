module "vpc-a" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "3.14.2"

    name                 = "${var.env}-vpc-a"
    cidr                 = "${var.cidr_prefix-a}.0.0/16"
    azs                  = data.aws_availability_zones.available.names
    private_subnets      = ["${var.cidr_prefix-a}.0.0/20", "${var.cidr_prefix-a}.16.0/20", "${var.cidr_prefix-a}.32.0/20"]
    public_subnets       = ["${var.cidr_prefix-a}.48.0/20", "${var.cidr_prefix-a}.64.0/20", "${var.cidr_prefix-a}.80.0/20"]
    enable_dns_hostnames = true
    enable_nat_gateway   = var.enable_nat_gateway
    single_nat_gateway   = var.single_nat_gateway

}

module "vpc-b" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "3.14.2"

    name                 = "${var.env}-vpc-b"
    cidr                 = "${var.cidr_prefix-b}.0.0/16"
    azs                  = data.aws_availability_zones.available.names
    private_subnets      = ["${var.cidr_prefix-b}.0.0/20", "${var.cidr_prefix-b}.16.0/20", "${var.cidr_prefix-b}.32.0/20"]
    public_subnets       = ["${var.cidr_prefix-b}.48.0/20", "${var.cidr_prefix-b}.64.0/20", "${var.cidr_prefix-b}.80.0/20"]
    enable_dns_hostnames = true
    enable_nat_gateway   = var.enable_nat_gateway
    single_nat_gateway   = var.single_nat_gateway
}

output "vpc-a-id" {
    value = module.vpc-a.vpc_id
  
}

output "vpc-b-id" {
  value = module.vpc-b.vpc_id
}