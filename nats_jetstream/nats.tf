resource "aws_instance" "nats-auth" {
  count                       = 1
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.nats_instance_type
  associate_public_ip_address = false
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.nats_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.id
  user_data                   = templatefile("${path.module}/cloud_init.init", { HOSTNAME="test-nats", 
                                                                                  NKEYS="true",
                                                                                  S3="nats-assets-${random_id.random-seed.dec}",
                                                                                  ENV="dev"})

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  depends_on = [
    "module.vpc"
  ]

}

resource "aws_security_group" "nats_sg" {
  name        = "nats-sg"
  description = "Allow egress traffic for nats"
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "all from local"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "all from local"
    from_port   = 4222
    to_port     = 4222
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  ingress {
    description = "all from local"
    from_port   = 8222
    to_port     = 8222
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
}