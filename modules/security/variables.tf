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
  description = "ID of the VPC where security groups will be created"
  type        = string

  validation {
    condition     = startswith(var.vpc_id, "vpc-")
    error_message = "vpc_id must be a valid VPC ID starting with vpc-."
  }
}

variable "app_port" {
  description = "Port listened to by the web application on EC2 instances"
  type        = number
  default     = 80

  validation {
    condition     = var.app_port > 0 && var.app_port <= 65535
    error_message = "app_port must be between 1 and 65535."
  }
}

variable "db_port" {
  description = "Port listened to by the RDS database"
  type        = number
  default     = 3306

  validation {
    condition     = var.db_port > 0 && var.db_port <= 65535
    error_message = "db_port must be between 1 and 65535."
  }
}

variable "allowed_http_cidrs" {
  description = "CIDR blocks allowed to access the Application Load Balancer over HTTP/HTTPS"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "storage_bucket_arn" {
  description = "ARN of the S3 bucket that EC2 instances may access when creating custom IAM roles"
  type        = string
  default     = ""
}

variable "use_existing_lab_role" {
  description = "Use pre-existing AWS Academy LabInstanceProfile instead of creating IAM roles"
  type        = bool
  default     = true
}

variable "existing_instance_profile_name" {
  description = "Name of the pre-existing IAM instance profile (when use_existing_lab_role is true)"
  type        = string
  default     = "LabInstanceProfile"
}