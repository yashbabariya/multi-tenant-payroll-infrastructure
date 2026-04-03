resource "aws_security_group" "ec2_sg" {
  vpc_id      = var.vpc_id
  name        = "ec2-sg"
  description = "Allow TLS inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "https"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "ssh"
    security_groups = [aws_security_group.bastion_host_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Bastion Host EC2 security group
resource "aws_security_group" "bastion_host_ec2_sg" {
  vpc_id      = var.vpc_id
  name        = "bastion-host-ec2-sg"
  description = "Allow TLS inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "ssh"
    cidr_blocks = [var.my_ip[0]]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// RDS Security Group
resource "aws_security_group" "rds_sg" {
  vpc_id      = var.vpc_id
  name        = "rds-sg"
  description = "Allow TLS inbound traffic"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }
}
