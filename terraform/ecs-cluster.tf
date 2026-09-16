resource "aws_ecs_cluster" "main" {
  name = "${var.resource_prefix}-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "${var.project_name} ECS Fargate cluster"
    Description = "ECS Fargate cluster for ECS-FrontEnd-Backend-Monitoring-Demo."
  }
}

resource "aws_cloudwatch_log_group" "ecs" {
  for_each = local.service_names

  name              = "/ecs/${var.resource_prefix}/${var.environment}/${each.key}"
  retention_in_days = 1

  tags = {
    Name        = "${var.project_name} ${each.key} logs"
    Description = "CloudWatch logs for the ECS-FrontEnd-Backend-Monitoring-Demo ${each.key} service."
  }
}