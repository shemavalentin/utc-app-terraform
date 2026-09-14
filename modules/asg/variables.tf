variable "project_name" {
  type    = string
  default = "3-tier-app"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for EC2 placement"
}

variable "app_security_group_id" {
  type        = string
  description = "Security Group ID for application instances"
}

variable "target_group_arn" {
  type        = string
  description = "Target Group ARN from the ALB module"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_id" {
  type        = string
  default     = ""
  description = "Optional AMI ID override; defaults to Amazon Linux 2023"
}

variable "user_data_base64" {
  type        = string
  default     = null
  description = "Base64 encoded bootstrap script"
}

variable "iam_instance_profile_arn" {
  type        = string
  default     = null
  description = "Optional IAM Instance Profile ARN for SSMAgent or CloudWatch logs"
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 5
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "tags" {
  type    = map(string)
  default = {}
}