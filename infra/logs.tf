# # logs.tf

# # Set up CloudWatch group and log stream and retain logs for 30 days
# resource "aws_cloudwatch_log_group" "bookorbit_log_group" {
#   name              = "/ecs/bookorbit-app"
#   retention_in_days = 30

#   tags = {
#     Name = "bookorbit-log-group"
#   }
# }

# resource "aws_cloudwatch_log_stream" "bookorbit_log_stream" {
#   name           = "bookorbit-log-stream"
#   log_group_name = aws_cloudwatch_log_group.cb_log_group.name
# }
