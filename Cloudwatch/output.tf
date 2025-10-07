

output "KKE_instance_name" {
  description = "The name tag of the created EC2 instance."
  value       = aws_instance.nautilus_ec2.tags.Name
}

output "KKE_alarm_name" {
  description = "The name of the created CloudWatch alarm."
  value       = aws_cloudwatch_metric_alarm.nautilus_alarm.alarm_name
}


