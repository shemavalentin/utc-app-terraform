variable "project_name" {
  type    = string
  default = "utc-app"
}

variable "log_retention_days" {
  type        = number
  default     = 30
  description = "Log retention period in days"
}

variable "alert_email" {
  type        = string
  default     = ""
  description = "Email address to receive SNS alert notifications"
}

variable "autoscaling_group_name" {
  type        = string
  description = "Target ASG name for CPU monitoring"
}

variable "cpu_threshold_percent" {
  type        = number
  default     = 80
  description = "CPU percentage threshold to trigger alarm"
}

variable "tags" {
  type    = map(string)
  default = {}
}