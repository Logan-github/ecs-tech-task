# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "demo-app-log-group" {
  name              = "/ecs/demo-app"
  retention_in_days = 30

  tags = {
    Name = "demo-cw-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "demo-app_log_stream" {
  name           = "demo-log-stream"
  log_group_name = aws_cloudwatch_log_group.demo-app-log-group.name
}