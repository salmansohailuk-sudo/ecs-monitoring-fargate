variable "aws_region" {
  type        = string
  description = "AWS region for the ECS-FrontEnd-Backend-Monitoring-Demo deployment."
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Display name for the ECS-FrontEnd-Backend-Monitoring-Demo project."
  default     = "ECS-FrontEnd-Backend-Monitoring-Demo"
}

variable "resource_prefix" {
  type        = string
  description = "Lowercase AWS-safe resource prefix."
  default     = "ecs-frontend-backend-monitoring-demo"
}

variable "environment" {
  type        = string
  description = "Deployment environment."
  default     = "sandbox"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR range for the ECS-FrontEnd-Backend-Monitoring-Demo VPC."
  default     = "10.50.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones used by the demo VPC."
  default     = ["us-east-1a", "us-east-1b"]
}

variable "image_tag" {
  type        = string
  description = "Docker image tag deployed to ECS."
  default     = "latest"
}

variable "stripe_secret_key" {
  type        = string
  description = "Temporary Stripe test secret key for the ECS backend."
  sensitive   = true
}

variable "stripe_webhook_secret" {
  type        = string
  description = "Temporary Stripe webhook signing secret for the ECS backend."
  sensitive   = true
}

variable "db_name" {
  type        = string
  description = "Application MySQL database name."
  default     = "ecommerce"
}

variable "db_username" {
  type        = string
  description = "Application MySQL username."
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Application MySQL password."
  sensitive   = true
}