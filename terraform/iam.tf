data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_execution" {
  name               = "${var.resource_prefix}-${var.environment}-ecs-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = {
    Name        = "${var.project_name} ECS execution role"
    Description = "Execution role for ECS-FrontEnd-Backend-Monitoring-Demo Fargate tasks."
  }
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "app_task" {
  name               = "${var.resource_prefix}-${var.environment}-app-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = {
    Name        = "${var.project_name} application task role"
    Description = "Application task role for ECS-FrontEnd-Backend-Monitoring-Demo."
  }
}

resource "aws_iam_role" "monitoring_task" {
  name               = "${var.resource_prefix}-${var.environment}-monitoring-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = {
    Name        = "${var.project_name} monitoring task role"
    Description = "CloudWatch read role for ECS-FrontEnd-Backend-Monitoring-Demo."
  }
}

resource "aws_iam_role_policy" "monitoring_cloudwatch_read" {
  role = aws_iam_role.monitoring_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "cloudwatch:GetMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "tag:GetResources"
      ]
      Resource = "*"
    }]
  })
}