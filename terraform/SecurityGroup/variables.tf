// vpc 
variable "vpc_id" {
  type = string
}

variable "my_ip" {
  type = list(string)
  description = "IP's allow in security-group"
}
