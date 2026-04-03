provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "ManagedBy"   = "Terraform"
      "Environment" = var.environment
      "Criticality" = "Low"
      "Department"  = "DevOps"
    }
  }
}

module "vpc" {
  source              = "./vpc"
  region              = var.region
  name                = var.name
  cidr_vpc            = var.cidr_vpc
  cidr_private_subnet = var.cidr_private_subnet
  cidr_public_subnet  = var.cidr_public_subnet
  availability_zone   = var.availability_zone
}

module "security_groups" {
  source = "./SecurityGroup"
  vpc_id = module.vpc.vpc_id
  my_ip = var.my_ip[0]
  depends_on = [ module.vpc ]
}

module "ec2" {
  source = "./ec2"
  ec2_sg_id = module.security_groups.ec2_sg_id
  environment = var.environment
  public_subnet = module.vpc.public_subnet_id
  private_subnet = module.vpc.private_subnet_id
  baction_host_sg_id = module.security_groups.bastion_host_ec2_sg_id
  ec2_instance_role_arn = module.iam.tenant_role_arn
  depends_on = [ module.iam, module.vpc, module.security_groups ]
}

module "rds" {
  source = "./rds"
  public_subnet_id = module.vpc.public_subnet_id
  rds_sg_id = module.security_groups.rds_sg_id
  depends_on = [ module.vpc, module.security_groups ]
}

module "s3" {
  source = "./s3"
}

module "iam" {
  source = "./iam"
  s3_bucket_arn = module.s3.s3_bucket_arn
  aws_secretsmanager_secret_arn = module.rds.aws_secretsmanager_secret
}