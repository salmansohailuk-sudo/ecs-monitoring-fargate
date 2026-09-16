variable "aws_region" {
  type        = string
  description = "AWS region for the demo."
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Project display name."
  default     = "ECS-FrontEnd-Backend-Monitoring-Demo"
}

variable "resource_prefix" {
  type        = string
  description = "Lowercase AWS-safe prefix."
  default     = "ecs-frontend-backend-monitoring-demo"
}

variable "environment" {
  type        = string
  description = "Deployment environment."
  default     = "sandbox"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR range."
  default     = "10.50.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones for the VPC."
  default     = ["us-east-1a", "us-east-1b"]
}

variable "image_tag" {
  type        = string
  description = "Image tag deployed to ECS."
  default     = "latest"
}