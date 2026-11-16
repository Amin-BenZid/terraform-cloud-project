variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project prefix for naming resources"
  type        = string
  default     = "cloud5"
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be dev, test, or prod."
  }
}

variable "owner" {
  description = "Owner tag for all resources"
  type        = string
  default     = "aminebenzid"
}

variable "vpc_cidr" {
  description = "Main /16 VPC CIDR block"
  type        = string
}

variable "single_nat_gateway" {
  description = "Use 1 NAT Gateway (cost-saving) vs 2 NAT Gateways (HA)"
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "EC2 instance type for the Auto Scaling Group"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum ASG instance count"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum ASG instance count"
  type        = number
  default     = 4
}

variable "desired_capacity" {
  description = "Desired ASG instance count"
  type        = number
  default     = 2
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_password" {
  description = "Master password for RDS (never commit; pass via TF_VAR_db_password)"
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Enable Multi-AZ for RDS"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "RDS backup retention days"
  type        = number
  default     = 1
}

variable "skip_final_snapshot" {
  description = "Skip RDS final snapshot on destroy"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable RDS deletion protection"
  type        = bool
  default     = false
}

variable "use_existing_lab_role" {
  description = "Use existing LabInstanceProfile in AWS Academy Learner Lab"
  type        = bool
  default     = true
}