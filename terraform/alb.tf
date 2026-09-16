resource "aws_lb" "main" {
  # AWS ALB names must be 32 characters or fewer
  # and cannot end with a hyphen.
  name               = "ecs-febm-demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = values(aws_subnet.public)[*].id

  tags = {
    Name        = "${var.project_name} public ALB"
    Description = "Public ALB for the ECS-FrontEnd-Backend-Monitoring-Demo frontend."
  }
}

resource "aws_lb_target_group" "frontend" {
  # This name is also under AWS's 32-character limit.
  name        = "ecs-febm-demo-fe-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled             = true
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "${var.project_name} frontend target group"
    Description = "ALB target group for the ECS-FrontEnd-Backend-Monitoring-Demo frontend."
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn = aws_lb_target_group.frontend.arn
      }
    }
  }
}