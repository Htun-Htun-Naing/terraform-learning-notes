resource "aws_sns_topic" "sns_topic" {
  name = "nautilus-sns-topic"
}


# 1. Launch the EC2 instance
resource "aws_instance" "nautilus_ec2" {
  ami           = "ami-0c02fb55956c7d316" # Ubuntu Server 20.04 LTS
  instance_type = "t2.micro"

  tags = {
    Name = "nautilus-ec2"
  }
}

# 2. Create the CloudWatch alarm for CPU Utilization
resource "aws_cloudwatch_metric_alarm" "nautilus_alarm" {
  alarm_name          = "nautilus-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300 # 5 minutes in seconds
  statistic           = "Average"
  threshold           = 90.0
  alarm_description   = "Triggered when CPU utilization exceeds 90% for 5 minutes."

  # Link the alarm specifically to the instance created above
  dimensions = {
    InstanceId = aws_instance.nautilus_ec2.id
  }

  # Specify the SNS topic for notifications
  alarm_actions = [data.aws_sns_topic.sns_topic.arn]
}