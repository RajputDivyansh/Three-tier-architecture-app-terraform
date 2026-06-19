// RDS Subnet Group
resource "aws_db_subnet_group" "main" {

  name = "${var.project_name}-db-subnet-group"

  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}


// RDS Parameter Group for PostgreSQL
resource "aws_db_parameter_group" "postgres" {

  name   = "${var.project_name}-postgres"
  family = "postgres17"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }
}


// RDS Instance for PostgreSQL
resource "aws_db_instance" "postgres" {

  identifier = "${var.project_name}-postgres"

  engine = "postgres"

  engine_version = "17"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  storage_type = "gp3"

  storage_encrypted = true

  db_name = var.db_name

  username = var.db_username

  password = var.db_password

  multi_az = true

  publicly_accessible = false

  skip_final_snapshot = true

  deletion_protection = false

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    var.db_sg_id
  ]

  parameter_group_name = aws_db_parameter_group.postgres.name

  backup_retention_period = 7

  auto_minor_version_upgrade = true

  apply_immediately = true
}