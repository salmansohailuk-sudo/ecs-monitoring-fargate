locals {
  ecr_repositories = toset([
    "frontend",
    "backend",
    "monitoring",
    "grafana"
  ])

  service_names = toset([
    "frontend",
    "backend",
    "monitoring",
    "grafana"
  ])
}