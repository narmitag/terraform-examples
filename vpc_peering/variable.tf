#Define AWS Region
variable "region" {
  description = "Infrastructure region"
  type        = string
  default     = "us-east-1"
}
variable "owner_vpc_id" {
  description = "$(owner_vpc_description)"
  default     = "vpc-094938f1a225d4425"
}
variable "accepter_vpc_id" {
  description = "$(accepter_vpc_description)"
  default     = "vpc-0ebf4ac134edec604"
  
}
