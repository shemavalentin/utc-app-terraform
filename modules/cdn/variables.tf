variable "alb_dns_name" {
  type        = string
  description = "DNS name of the origin Application Load Balancer"
}

variable "domain_name" {
  type        = string
  description = "Custom domain name / alias for CloudFront (e.g., example.com)"
}

variable "hosted_zone_domain" {
  type        = string
  description = "Base Route 53 hosted zone domain (e.g., example.com)"
}

variable "project_name" {
  type        = string
  default     = "3-tier-app"
}

variable "tags" {
  type        = map(string)
  default     = {}
}