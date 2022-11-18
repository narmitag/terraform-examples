provider "aws" {
  region = "us-east-1"
}



module "terraform-aws-bastion-ssm-iam" {
  source = "./module"

  # The name used to interpolate in the resources, defaults to bastion-ssm-iam
  # name = "bastion-ssm-iam"

  # The vpc id
  vpc_id = module.vpc.vpc_id

  # subnet_ids designates the subnets where the bastion can reside
  subnet_ids = module.vpc.private_subnets
  

  # The module creates a security group for the bastion by default
  # create_security_group = true

  # The module can create a diffent ssm document for this deployment, to allow
  # different security models per BASTION deployment
  # create_new_ssm_document = false

  # It is possible to attach other security groups to the bastion.
  # security_group_ids = []
}
