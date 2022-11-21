#Define AWS Region
variable "region" {
  description = "Infrastructure region"
  type        = string
  default     = "us-east-1"
}
# variable "owner_vpc_id" {
#   description = "$(owner_vpc_description)"
#   default     = "vpc-094938f1a225d4425"
# }
# variable "accepter_vpc_id" {
#   description = "$(accepter_vpc_description)"
#   default     = "vpc-0ebf4ac134edec604"
  
# }


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
