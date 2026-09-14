output "autoscaling_group_id" {
  value = aws_autoscaling_group.app.id
}

output "launch_template_id" {
  value = aws_launch_template.app.id
}
