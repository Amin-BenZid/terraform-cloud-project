locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = var.private_db_subnet_ids

  tags = {
    Name = "${local.name_prefix}-db-subnet-group"
  }
}

resource "aws_db_parameter_group" "this" {
  name        = "${local.name_prefix}-mysql84-pg"
  family      = "mysql8.4"
  description = "Custom MySQL 8.4 parameter group for ${local.name_prefix}"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${local.name_prefix}-mysql84-pg"
  }
}

resource "aws_db_instance" "this" {
  identifier = "${local.name_prefix}-rds"

  engine                     = "mysql"
  engine_version             = "8.4"
  instance_class             = var.db_instance_class
  allocated_storage          = 20
  max_allocated_storage      = 50
  storage_type               = "gp3"
  storage_encrypted          = true
  auto_minor_version_upgrade = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  parameter_group_name   = aws_db_parameter_group.this.name
  vpc_security_group_ids = [var.db_security_group_id]
  publicly_accessible    = false

  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection

  final_snapshot_identifier = var.skip_final_snapshot ? null : "${local.name_prefix}-final-snapshot"

  lifecycle {
    ignore_changes = [engine_version]
  }

  tags = {
    Name = "${local.name_prefix}-rds"
  }
}