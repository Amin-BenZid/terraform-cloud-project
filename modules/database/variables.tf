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

variable "private_db_subnet_ids" {
  description = "List of at least two private database subnet IDs in different AZs"
  type        = list(string)

  validation {
    condition     = length(var.private_db_subnet_ids) >= 2
    error_message = "RDS DB Subnet Group requires at least two subnets across different AZs."
  }
}

variable "db_security_group_id" {
  description = "Security Group ID attached to the RDS instance"
  type        = string

  validation {
    condition     = startswith(var.db_security_group_id, "sg-")
    error_message = "db_security_group_id must be a valid Security Group ID starting with sg-."
  }
}

variable "db_instance_class" {
  description = "RDS instance class (e.g. db.t3.micro)"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Initial database name created on the RDS instance"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for the RDS database"
  type        = string
  default     = "adminuser"

  validation {
    condition     = length(var.db_username) >= 3 && var.db_username != "admin"
    error_message = "db_username must be at least 3 characters and not reserved (avoid 'admin' if needed across engines)."
  }
}

variable "db_password" {
  description = "Master password for the RDS database (pass via TF_VAR_db_password or CI secret, never commit)"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8 && !can(regex("[/@\" ]", var.db_password))
    error_message = "db_password must be at least 8 characters and must not contain '/', '@', '\"', or spaces."
  }
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment for high availability (recommended true for prod)"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 1

  validation {
    condition     = var.backup_retention_period >= 0 && var.backup_retention_period <= 35
    error_message = "backup_retention_period must be between 0 and 35."
  }
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying RDS (true for dev/test, false for prod)"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Protect RDS instance from accidental deletion"
  type        = bool
  default     = false
}