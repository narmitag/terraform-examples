data "aws_security_group" "default" {
    name   = "default"
    vpc_id = module.vpc.vpc_id
}
resource "aws_security_group" "vpc_tls" {
  name_prefix = "neil-vpc_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

module "vpc_endpoints" {
    source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
    version = "3.14.2"

    vpc_id             = module.vpc.vpc_id
    security_group_ids = [data.aws_security_group.default.id]

    endpoints = {
     ssm = {
        service             = "ssm"
        private_dns_enabled = true
        subnet_ids          = module.vpc.private_subnets
        security_group_ids  = [aws_security_group.vpc_tls.id]
      },
      ssmmessages = {
        service             = "ssmmessages"
        private_dns_enabled = true
        subnet_ids          = module.vpc.private_subnets
                security_group_ids  = [aws_security_group.vpc_tls.id]
      },
      ec2 = {
        service             = "ec2"
        private_dns_enabled = true
        subnet_ids          = module.vpc.private_subnets
        security_group_ids  = [data.aws_security_group.default.id]
      },
      ec2messages = {
        service             = "ec2messages"
        private_dns_enabled = true
        subnet_ids          = module.vpc.private_subnets
                security_group_ids  = [aws_security_group.vpc_tls.id]
      },
      kms = {
        service             = "kms"
        private_dns_enabled = true
        subnet_ids          = module.vpc.private_subnets
        security_group_ids  = [aws_security_group.vpc_tls.id]
      },
      logs = {
        service             = "logs"
        private_dns_enabled = true
        subnet_ids          = module.vpc.private_subnets
        security_group_ids  = [aws_security_group.vpc_tls.id]
      },
    }

}