resource "aws_db_subnet_group" "mysql" {
  name       = "${var.resource_prefix}-${var.environment}-mysql"
  subnet_ids = values(aws_subnet.private)[*].id

  tags = {
    Name        = "ecs-febm-demo-mysql-subnet-group"
    Description = "Private subnets for ECS MySQL database"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.resource_prefix}-${var.environment}-rds"
  description = "MySQL access from ECS tasks only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from ECS backend"
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    description = "Outbound traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ecs-febm-demo-rds-security-group"
    Description = "Security group for ECS MySQL database"
  }
}

resource "aws_db_instance" "mysql" {
  identifier = "${var.resource_prefix}-${var.environment}-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 3306

  db_subnet_group_name   = aws_db_subnet_group.mysql.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible     = false
  multi_az                = false
  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false
  apply_immediately       = true

  tags = {
    Name        = "ecs-febm-demo-mysql"
    Description = "MySQL database for ECS application"
  }
}