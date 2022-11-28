variable "environment_name" {
  type = string
  default = "dev"
}
variable "production" {
  type    = bool
  default = false
}

variable "region" {
  default = "us-east-1"
}

variable "eks_cluster_name" {
  type = string
  default = "dev-cluster"
}

variable "eks_desired_nodes" {
  type    = number
  default = 1
}


variable "eks_version" {
  type    = string
  default = "1.21"
}



variable "cert_manager_version" {
  description = "Version for the cert manager"
  default     = "1.7.1"
}

variable "cluster_autoscaler_version" {
  description = "CA version"
  default     = "1.21.2"
}

variable "ingress_version" {
  description = "Ingress Version"
  default     = "3.33.0"
}

variable "secret_agent_version" {
  default = "1.1.4"
}

