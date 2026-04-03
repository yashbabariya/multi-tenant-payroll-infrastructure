// VPC
variable "region" {
  type        = string
  description = "aws region"
}

variable "environment" {
  type        = string
  description = "Environment (DEV, STAGE, and PROD)"
}

variable "availability_zone" {
  type        = list(string)
  description = "availability zone"
}

variable "name" {
  type        = string
  description = "Name of VPC, subnet, IGW, NAT, and Routetables"
  default     = "ocean"
}

variable "cidr_vpc" {
  type        = string
  description = "VPC cidr"
  default     = "10.0.0.0/16"
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "Puvlic Subnet CIDR"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "Private Subnete CIDR"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "my_ip" {
  type = list(string)
  description = "IP's allow on secuirtygroup ingress traffic"
}