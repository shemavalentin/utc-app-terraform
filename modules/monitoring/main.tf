# 1. CloudWatch Log Group for Application Logs
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/aws/ec2/${var.project_name}-app-logs"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, { Name = "${var.project_name}-log-group" })
}

# 2. SNS Topic for Alert Notifications
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-system-alerts"

  tags = merge(var.tags, { Name = "${var.project_name}-alerts-topic" })
}

# 3. SNS Email Subscription
resource "aws_sns_topic_subscription" "email_alert" {
  count     = var.alert_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# 4. CloudWatch Metric Alarm: High ASG CPU Utilization
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-asg-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_threshold_percent
  alarm_description   = "Triggers when average ASG CPU exceeds ${var.cpu_threshold_percent}%"

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]

  tags = merge(var.tags, { Name = "${var.project_name}-cpu-alarm" })
}
