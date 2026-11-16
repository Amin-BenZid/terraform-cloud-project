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

variable "instance_type" {
  description = "EC2 instance type for application servers"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
  default     = 2

  validation {
    condition     = var.min_size >= 1
    error_message = "min_size must be at least 1."
  }
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
  default     = 4

  validation {
    condition     = var.max_size >= 1
    error_message = "max_size must be at least 1."
  }
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group"
  type        = number
  default     = 2

  validation {
    condition     = var.desired_capacity >= 1
    error_message = "desired_capacity must be at least 1."
  }
}

variable "private_app_subnet_ids" {
  description = "List of private application subnet IDs across at least two Availability Zones"
  type        = list(string)

  validation {
    condition     = length(var.private_app_subnet_ids) >= 2
    error_message = "ASG requires at least two private subnets in different Availability Zones."
  }
}

variable "app_security_group_id" {
  description = "Security Group ID for application EC2 instances"
  type        = string

  validation {
    condition     = startswith(var.app_security_group_id, "sg-")
    error_message = "app_security_group_id must be a valid Security Group ID starting with sg-."
  }
}

variable "ec2_instance_profile_name" {
  description = "IAM Instance Profile name attached to EC2 instances"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB Target Group to register ASG instances with"
  type        = string
}

variable "cpu_target_value" {
  description = "Target average CPU utilization percentage for Auto Scaling"
  type        = number
  default     = 70
}