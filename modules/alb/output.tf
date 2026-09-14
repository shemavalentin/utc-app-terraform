output "alb_dns_name" {
  description = "DNS name of the Load Balancer"
  value       = aws_lb.main.dns_name
}

output "target_group_arn" {
  description = "ARN of the Target Group to pass to Auto Scaling Group"
  value       = aws_lb_target_group.app.arn
}
