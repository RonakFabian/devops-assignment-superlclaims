resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/backend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "worker" {
  name              = "/ecs/worker"
  retention_in_days = 7
}
