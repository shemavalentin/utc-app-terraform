variable "project_name" {
  type    = string
  default = "3-tier-app"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs where the DB Subnet Group will be deployed"
}

variable "db_security_group_id" {
  type        = string
  description = "Security Group ID for the database"
}

variable "engine" {
  type    = string
  default = "postgres"
}

variable "engine_version" {
  type    = string
  default = "15.4"
}

variable "instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "dbadmin"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Master database password"
}

variable "backup_retention_period" {
  type        = number
  default     = 7
  description = "Number of days to retain automated backups"
}

variable "backup_window" {
  type        = string
  default     = "03:00-04:00"
  description = "Preferred daily backup window (UTC)"
}

variable "maintenance_window" {
  type        = string
  default     = "Sun:04:30-Sun:05:30"
  description = "Preferred weekly maintenance window (UTC)"
}

variable "multi_az" {
  type        = bool
  default     = false
  description = "Enable Multi-AZ deployment for high availability"
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}