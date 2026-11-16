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

variable "noncurrent_expiration_days" {
  description = "Number of days after which noncurrent object versions expire"
  type        = number
  default     = 30

  validation {
    condition     = var.noncurrent_expiration_days >= 1
    error_message = "noncurrent_expiration_days must be at least 1."
  }
}

variable "transition_ia_days" {
  description = "Number of days before transitioning current objects to STANDARD_IA"
  type        = number
  default     = 30

  validation {
    condition     = var.transition_ia_days >= 30
    error_message = "S3 STANDARD_IA requires transition_ia_days to be at least 30."
  }
}

variable "use_cli_bucket_creation" {
  description = "Create/delete the S3 bucket via AWS CLI to bypass Learner Lab SCP on s3:GetBucketObjectLockConfiguration"
  type        = bool
  default     = true
}