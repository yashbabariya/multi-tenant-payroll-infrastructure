output "vpc_id" {
  description = "VPC id"
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  description = "public subnet ids"
    value = [ for s in aws_subnet.public_subnet : s.id]
}

output "private_subnet_id" {
  description = "private subnet ids"
  value = [ for s in aws_subnet.private_subnet : s.id ]
}

output "nat_gateway_public_ip" {
  description = "get the natgateway public ip"
  value = aws_nat_gateway.private_nat_gateway.public_ip
}