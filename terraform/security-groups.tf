resource "aws_security_group" "alb" {
  name        = "${var.resource_prefix}-${var.environment}-alb"
  description = "Public ALB security group for ECS-FrontEnd-Backend-Monitoring-Demo."
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP access to the frontend."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "ALB outbound traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs" {
  name        = "${var.resource_prefix}-${var.environment}-ecs"
  description = "Private ECS service security group for ECS-FrontEnd-Backend-Monitoring-Demo."
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "ALB to frontend Nginx."
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description = "Frontend to backend."
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Prometheus to Nginx exporter."
    from_port   = 9113
    to_port     = 9113
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Grafana and Prometheus internal traffic."
    from_port   = 3000
    to_port     = 9090
    protocol    = "tcp"
    self        = true
  }

  egress {
    description = "Fargate task outbound traffic through NAT."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ecs_from_alb_backend" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ecs.id
  source_security_group_id = aws_security_group.alb.id
  protocol                 = "tcp"
  from_port                = 5000
  to_port                  = 5000
  description              = "Backend traffic from ALB"
}

resource "aws_security_group_rule" "ecs_from_alb_grafana" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ecs.id
  source_security_group_id = aws_security_group.alb.id
  protocol                 = "tcp"
  from_port                = 3000
  to_port                  = 3000
  description              = "Grafana traffic from ALB"
}

resource "aws_security_group_rule" "ecs_from_alb_prometheus" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ecs.id
  source_security_group_id = aws_security_group.alb.id
  protocol                 = "tcp"
  from_port                = 9090
  to_port                  = 9090
  description              = "Prometheus traffic from ALB"
}