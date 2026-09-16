output "project_name" {
  value       = var.project_name
  description = "ECS-FrontEnd-Backend-Monitoring-Demo project name."
}

output "cluster_name" {
  value       = aws_ecs_cluster.main.name
  description = "ECS Fargate cluster name."
}

output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "Public ALB DNS name."
}

output "ecr_repository_urls" {
  value = {
    for name, repository in aws_ecr_repository.app :
    name => repository.repository_url
  }
}