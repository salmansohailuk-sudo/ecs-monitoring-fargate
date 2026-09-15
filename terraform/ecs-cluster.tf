resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

locals {
  log_groups = toset([
    "frontend",
    "backend",
    "monitoring",
    "grafana"
  ])
}

resource "aws_cloudwatch_log_group" "ecs" {
  for_each = local.log_groups

  name              = "/ecs/${var.project_name}/${var.environment}/${each.key}"
  retention_in_days = 1
}