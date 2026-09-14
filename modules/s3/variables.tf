variable "project_name" {
  type    = string
  default = "utc-app"
}
variable "environment" {
  type    = string
  default = "dev"
}

variable "bucket_suffix" {
  type        = string
  description = "Unique random string/suffix for bucket naming"
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
