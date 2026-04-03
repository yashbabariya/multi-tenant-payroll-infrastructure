// Create random password
resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret" "db_secret" {
  name = "payroll-db-credentials"
}

resource "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  depends_on = [ random_password.db_password, aws_secretsmanager_secret.db_secret ]

  secret_string = jsonencode({
    username = "admin"
    password = random_password.db_password.result
    host     = aws_db_instance.postgres.address
    database = "payrolldb"
  })
}

resource "aws_db_subnet_group" "main" {
  name       = "db-subnet-group"
  subnet_ids = var.public_subnet_id[0]
}

resource "aws_db_parameter_group" "postgres_secure" {
  name   = "postgres-secure"
  family = "postgres16"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  tags = {
    Name = "secure-parameter-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "payroll-db"
  depends_on = [ aws_secretsmanager_secret.db_secret, aws_db_parameter_group.postgres_secure ]

  engine         = "postgres"
  engine_version = "15"
  instance_class = "db.t3.micro"

  allocated_storage = 10
  storage_type      = "gp3"

  db_name  = "payrolldb"
  username = "admin"
  password = random_password.db_password.result

  db_subnet_group_name   = var.public_subnet_id
  vpc_security_group_ids = [var.rds_sg_id]

  # SECURITY SETTINGS
  publicly_accessible = true
  storage_encrypted   = true
  deletion_protection = true

  # BACKUP
  backup_retention_period = 7
  skip_final_snapshot     = true

  # AVAILABILITY
  multi_az = false   # keep false for free-tier

  # MONITORING
  monitoring_interval = 0

  # PARAMETER GROUP
  parameter_group_name = aws_db_parameter_group.postgres_secure.name

  # DISABLE AUTO MINOR VERSION UPGRADE (controlled env)
  auto_minor_version_upgrade = false

  tags = {
    Name = "secure-payroll-db"
  }
}