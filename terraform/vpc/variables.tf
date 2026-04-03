variable "region" {
  type    = string
}

variable "name" {
  type    = string
  description = "Name of VPC, subnet, IGW, NAT, and Routetables."
}

variable "cidr_vpc" {
  type        = string
  description = "VPC CIDR values."
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}