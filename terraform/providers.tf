provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Description = "ECS-FrontEnd-Backend-Monitoring-Demo sandbox deployment"
      AWSRegion   = var.aws_region
    }
  }
}