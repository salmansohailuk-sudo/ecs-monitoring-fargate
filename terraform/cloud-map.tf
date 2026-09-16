# Private DNS namespace used by the ECS-FrontEnd-Backend-Monitoring-Demo services.
#
# Internal names:
#   frontend.ecs-test.local
#   backend.ecs-test.local
#   monitoring.ecs-test.local
#   grafana.ecs-test.local
#
# This namespace is available only inside the new VPC.

resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = "ecs-test.local"
  description = "Private Cloud Map namespace for ECS-FrontEnd-Backend-Monitoring-Demo."
  vpc         = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name} Cloud Map namespace"
    Description = "Private service discovery namespace for ECS-FrontEnd-Backend-Monitoring-Demo."
  }
}

resource "aws_service_discovery_service" "frontend" {
  name = "frontend"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  tags = {
    Name        = "${var.project_name} frontend discovery service"
    Description = "Cloud Map registration for the ECS-FrontEnd-Backend-Monitoring-Demo frontend."
  }
}

resource "aws_service_discovery_service" "backend" {
  name = "backend"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  tags = {
    Name        = "${var.project_name} backend discovery service"
    Description = "Cloud Map registration for the ECS-FrontEnd-Backend-Monitoring-Demo backend."
  }
}

resource "aws_service_discovery_service" "monitoring" {
  name = "monitoring"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  tags = {
    Name        = "${var.project_name} monitoring discovery service"
    Description = "Cloud Map registration for the ECS-FrontEnd-Backend-Monitoring-Demo monitoring service."
  }
}

resource "aws_service_discovery_service" "grafana" {
  name = "grafana"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  tags = {
    Name        = "${var.project_name} Grafana discovery service"
    Description = "Cloud Map registration for the ECS-FrontEnd-Backend-Monitoring-Demo Grafana service."
  }
}