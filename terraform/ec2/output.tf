output "bastion_ec2_public_IP" {
  value = aws_instance.bastion_ec2.public_ip
}

output "tenant_ec2_public_IP" {
  value = aws_instance.tenant_ec2.public_ip
}