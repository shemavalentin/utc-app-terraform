# 1. DB Subnet Group (Restricts RDS placement to private subnets)
resource "aws_db_subnet_group" "rds" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, { Name = "${var.project_name}-db-subnet-group" })
}

# 2. RDS PostgreSQL / MySQL Instance
resource "aws_db_instance" "main" {
  identifier          = "rds-${var.project_name}-db"
  engine              = var.engine
  engine_version      = var.engine_version
  instance_class      = var.instance_class
  allocated_storage   = var.allocated_storage
  storage_type        = "gp3"
  skip_final_snapshot = var.skip_final_snapshot

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [var.db_security_group_id]

  # Backup & Maintenance Configuration
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  multi_az                = var.multi_az

  tags = merge(var.tags, { Name = "${var.project_name}-db" })
}
