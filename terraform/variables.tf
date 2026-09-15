variable "aws_region" {
  type        = string
  description = "AWS region for the deployment."
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Short project name used in resource names."
  default     = "ecommerce-monitoring"
}

variable "environment" {
  type        = string
  description = "Deployment environment."
  default     = "sandbox"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR range for the new VPC."
  default     = "10.50.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "Two Availability Zones in the selected region."
  default     = ["us-east-2a", "us-east-2b"]
}

variable "image_tag" {
  type        = string
  description = "ECR tag used by ECS task definitions."
  default     = "latest"
}

variable "github_repository" {
  type        = string
  description = "GitHub repository in owner/repository form."
  default     = "ecs-monitoring-fargate"
}