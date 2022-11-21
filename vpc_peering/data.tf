data "aws_caller_identity" "owner" {
      provider      = aws.owner
}

data "aws_caller_identity" "accepter" {
      provider      = aws.accepter
}

data "aws_availability_zones" "available" {}