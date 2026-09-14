variable "project_name" {
  type    = string
  default = "utc-app"
}

variable "recovery_window_in_days" {
  type    = number
  default = 0
}

variable "db_engine" {
  type    = string
  default = "postgres"
}

variable "db_host" { type = string }

variable "db_port" {
  type    = number
  default = 5432
}

variable "db_name" { type = string }
variable "db_username" { type = string }

variable "db_password" {
  type      = string
  sensitive = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
