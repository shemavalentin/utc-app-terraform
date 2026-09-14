variable "project_name" {
  type    = string
  default = "utc-app"
}

variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "app_security_group_id" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
