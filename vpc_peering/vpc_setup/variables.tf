variable "cidr_prefix-a" {
    type = string
    description = "CIDR Block for VPC"
    default = "10.200"
}
variable "cidr_prefix-b" {
    type = string
    description = "CIDR Block for VPC"
    default = "10.201"
}

variable "enable_nat_gateway" {
    type = bool
    description = "Enable Nat Gateways"
    default = false
}

variable "single_nat_gateway" {
    type = bool
    description = "Single Nat Gateway"
    default = true
}

variable "env" {
    type = string
    description = "Environment Name"
    default = "dev"
}

variable "region" {
    type = string
    description = "AWS Region"
    default = "eu-west-2"
}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

# variable "clients" {
#     default = ["xxxxxxxx", "xxxxxx"]
  
# }