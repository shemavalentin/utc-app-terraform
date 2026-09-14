output "secret_arn" {
  description = "ARN of the database secrets container"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "secret_name" {
  description = "Name of the database secret"
  value       = aws_secretsmanager_secret.db_credentials.name
}
