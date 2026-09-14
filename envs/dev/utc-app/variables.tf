variable "db_password" {
  type        = string
  description = "Master password for the RDS PostgreSQL database"
  sensitive   = true
}
