variable "project_name" {
  type    = string
  default = "utc-app"
}

variable "s3_bucket_arn" {
  type        = string
  description = "ARN of the application S3 bucket for restricted policy access"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "secret_arn" { type = string }
