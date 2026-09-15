resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb"
  description = "Public access to the Application Load Balancer."
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "ALB outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-${var.environment}-ecs"
  description = "Private ECS service communication."
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "ALB to frontend"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description = "Frontend to backend"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Monitoring scrape ports"
    from_port   = 9113
    to_port     = 9113
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Prometheus and Grafana internal communication"
    from_port   = 3000
    to_port     = 9090
    protocol    = "tcp"
    self        = true
  }

  egress {
    description = "Private tasks outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}