variable "vpc_id" {
  type        = string
  description = "VPC ID where the target group is attached"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs where ALB is deployed"
}

variable "alb_security_group_id" {
  type        = string
  description = "Security Group ID associated with the ALB"
}

variable "domain_name" {
  type        = string
  description = "Exact domain name requested for the ACM Certificate (e.g., *.example.com or example.com)"
}

variable "hosted_zone_domain" {
  type        = string
  description = "The base domain name registered in Route 53 (e.g., example.com)"
}

variable "app_port" {
  type        = number
  default     = 8080
  description = "Port the backend EC2 application listens on"
}

variable "health_check_path" {
  type        = string
  default     = "/"
  description = "Health check path for target group"
}

variable "project_name" {
  type    = string
  default = "3-tier-app"
}

variable "tags" {
  type    = map(string)
  default = {}
}
