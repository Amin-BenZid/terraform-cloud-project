variable "project_name" {
  description = "Project prefix used for resource naming"
  type        = string

  validation {
    condition     = length(trimspace(var.project_name)) > 0
    error_message = "project_name must not be empty."
  }
}

variable "environment" {
  description = "Target deployment environment (dev, test, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, prod."
  }
}

variable "vpc_id" {
  description = "VPC ID where the Target Group will be created"
  type        = string

  validation {
    condition     = startswith(var.vpc_id, "vpc-")
    error_message = "vpc_id must be a valid VPC ID starting with vpc-."
  }
}

variable "public_subnet_ids" {
  description = "List of at least two public subnet IDs for the ALB"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "ALB requires at least two public subnets in different Availability Zones."
  }
}

variable "alb_security_group_id" {
  description = "Security Group ID attached to the ALB"
  type        = string

  validation {
    condition     = startswith(var.alb_security_group_id, "sg-")
    error_message = "alb_security_group_id must be a valid Security Group ID starting with sg-."
  }
}

variable "app_port" {
  description = "Port on which the application instances listen"
  type        = number
  default     = 80

  validation {
    condition     = var.app_port > 0 && var.app_port <= 65535
    error_message = "app_port must be between 1 and 65535."
  }
}

variable "health_check_path" {
  description = "HTTP path used for Target Group health checks"
  type        = string
  default     = "/"
}