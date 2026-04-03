output "bastion_ec2_public_IP" {
  value = module.ec2.bastion_ec2_public_IP
}

output "tenant_ec2_public_IP" {
  value = module.ec2.tenant_ec2_public_IP
}
