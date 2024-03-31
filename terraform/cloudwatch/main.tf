resource "aws_sns_topic" "cpu_alert" {
  name = "cpu-alert"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.cpu_alert.arn
  protocol  = "email"
  endpoint  = "jeffersonvalente1988@gmail.com"
}


resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "High CPU Utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors the CPU utilization of an EC2 instance and triggers an alarm if it exceeds 80%."
  alarm_actions       = [aws_sns_topic.cpu_alert.arn]
  dimensions = {
    InstanceId = var.ec2_instance
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_alarm" {
  alarm_name          = "High Memory Utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors the memory utilization of an EC2 instance and triggers an alarm if it exceeds 70%."
  alarm_actions       = [aws_sns_topic.cpu_alert.arn]
  dimensions = {
    InstanceId = var.ec2_instance
  }
}

resource "aws_cloudwatch_metric_alarm" "network_connections_alarm" {
  alarm_name          = "High Network Connections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "Netstat_Tcp_Connections"
  namespace           = "CWAgent"
  period              = "60"
  statistic           = "Sum"
  threshold           = "100"
  alarm_description   = "This metric monitors the number of network connections of an EC2 instance and triggers an alarm if it exceeds 100."
  alarm_actions       = [aws_sns_topic.cpu_alert.arn]
  dimensions = {
    InstanceId = var.ec2_instance
  }
}

resource "aws_cloudwatch_metric_alarm" "http_status_5xx_alarm" {
  alarm_name          = "HTTP 5xx Errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_Backend_5XX"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm triggered when there are HTTP 5xx errors."
  alarm_actions       = [aws_sns_topic.cpu_alert.arn]

  dimensions = {
    InstanceId = var.ec2_instance
  }
}

resource "aws_cloudwatch_metric_alarm" "http_response_time_alarm" {
  alarm_name          = "HTTP Response Time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "Latency"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 1000
  alarm_description   = "Alarm triggered when HTTP response time exceeds 1 second."
  alarm_actions       = [aws_sns_topic.cpu_alert.arn]

  dimensions = {
    InstanceId = var.ec2_instance
  }
}