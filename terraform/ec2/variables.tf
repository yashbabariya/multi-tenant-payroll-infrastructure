variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "private_subnet" {
  type = list(string)
}

variable "public_subnet" {
  type = list(string)
}

variable "ec2_sg_id" {
  type = string
}

variable "baction_host_sg_id" {
  type = string
  description = "Bastion Host EC2 Security Group ID"
}

variable "environment" {
  type = string
  description = "DEV, STAGE, and PROD"
}

variable "ec2_instance_role_arn" {
  type = string
  description = "EC2 Instance IAM Role"
}