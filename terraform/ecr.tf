resource "aws_ecr_repository" "app" {
  for_each = local.ecr_repositories

  name                 = "${var.resource_prefix}/${each.key}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.project_name} ${each.key} ECR repository"
    Description = "Container repository for the ECS-FrontEnd-Backend-Monitoring-Demo ${each.key} service."
  }
}