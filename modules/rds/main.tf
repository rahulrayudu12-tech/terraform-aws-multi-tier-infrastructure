resource "aws_db_subnet_group" "database" {
  name       = "${var.project_name}-${var.environment}-db"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnets"
  }
}

resource "aws_db_instance" "database" {
  identifier                  = "${var.project_name}-${var.environment}-mysql"
  engine                      = "mysql"
  instance_class              = var.db_instance_class
  allocated_storage           = var.allocated_storage
  max_allocated_storage       = max(var.allocated_storage, 30)
  storage_type                = "gp3"
  storage_encrypted           = true
  db_name                     = var.db_name
  username                    = var.db_username
  manage_master_user_password = true
  db_subnet_group_name        = aws_db_subnet_group.database.name
  vpc_security_group_ids      = [var.db_security_group_id]
  publicly_accessible         = false
  multi_az                    = false
  backup_retention_period     = var.backup_retention_days
  auto_minor_version_upgrade  = true
  deletion_protection         = false
  skip_final_snapshot         = true
  apply_immediately           = false

  tags = {
    Name = "${var.project_name}-${var.environment}-mysql"
  }
}
