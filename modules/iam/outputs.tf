output "instance_profile_arn" {
  description = "ARN of the IAM Instance Profile for EC2 Launch Template"
  value       = aws_iam_instance_profile.app_profile.arn
}

output "role_name" {
  description = "Name of the EC2 IAM Role"
  value       = aws_iam_role.app_role.name
}
