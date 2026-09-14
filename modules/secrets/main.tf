# Generate a secure, random suffix for secret recovery/versioning
resource "random_id" "secret_suffix" {
  byte_length = 4
}

# 1. AWS Secrets Manager Secret Container
resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "${var.project_name}-db-credentials-${random_id.secret_suffix.hex}"
  recovery_window_in_days = var.recovery_window_in_days

  tags = merge(var.tags, { Name = "${var.project_name}-db-secret" })
}

# 2. Secret Version storing structured JSON credentials
resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    engine   = var.db_engine
    host     = var.db_host
    port     = var.db_port
    dbname   = var.db_name
    username = var.db_username
    password = var.db_password
  })
}
