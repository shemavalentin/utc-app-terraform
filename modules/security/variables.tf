variable "vpc_id" {
  type        = string
  description = "VPC ID where security groups will be created"
}

variable "project_name" {
  type        = string
  default     = "3-tier-app"
}

variable "app_port" {
  type        = number
  default     = 8080
  description = "Port on which the EC2 application runs"
}

variable "db_port" {
  type        = number
  default     = 5432
  description = "Port for RDS (e.g., 5432 for PostgreSQL, 3306 for MySQL)"
}

variable "tags" {
  type        = map(string)
  default     = {}
}