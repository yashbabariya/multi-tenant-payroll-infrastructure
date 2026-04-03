locals {
  tenants = ["company", "bureau", "employee"]
}

## Create SSH-key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "payroll-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/ssh-keys/payroll-key.pem"

  file_permission = "0400"
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile-role"
  role = var.ec2_instance_role_arn
}

# EC2 Instances
resource "aws_instance" "tenant_ec2" {
  count         = length(local.tenants)
  ami           = "ami-0f58b397bc5c1f2e8" # Amazon Linux 2 (Mumbai region)
  instance_type = var.instance_type

  subnet_id              = var.private_subnet[count.index]
  vpc_security_group_ids = [var.ec2_sg_id]
  key_name               = aws_key_pair.generated_key.key_name
  depends_on             = [aws_iam_instance_profile.ec2_profile]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # User Data (bootstrap script)
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              EOF

  tags = {
    Name        = "${local.tenants[count.index]}-ec2"
    Environment = var.environment
    Tenant      = local.tenants[count.index]
  }
}

## Bastion host
resource "aws_instance" "bastion_ec2" {
  ami           = "ami-0f58b397bc5c1f2e8" # Amazon Linux 2 (Mumbai region)
  instance_type = var.instance_type
  depends_on    = [aws_instance.tenant_ec2]

  subnet_id              = var.public_subnet[0]
  vpc_security_group_ids = [var.baction_host_sg_id]
  key_name               = aws_key_pair.generated_key.key_name

  tags = {
    Name        = "Bastion-host-ec2"
    Environment = var.environment
  }
}
