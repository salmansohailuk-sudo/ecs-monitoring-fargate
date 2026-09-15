locals {
  ecr_repositories = toset([
    "frontend",
    "backend",
    "monitoring",
    "grafana"
  ])
}

resource "aws_ecr_repository" "app" {
  for_each = local.ecr_repositories

  name                 = "${var.project_name}/${each.key}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}

output "ecr_repository_urls" {
  value = {
    for name, repository in aws_ecr_repository.app :
    name => repository.repository_url
  }
}