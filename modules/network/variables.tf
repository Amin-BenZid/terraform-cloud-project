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

variable "vpc_cidr" {
  description = "CIDR block for the VPC (must be a /16 block for subnet layout)"
  type        = string
  default     = "10.20.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr)) && tonumber(split("/", var.vpc_cidr)[1]) == 16
    error_message = "vpc_cidr must be a valid /16 IPv4 CIDR block (e.g. 10.20.0.0/16)."
  }
}

variable "single_nat_gateway" {
  description = "Deploy a single shared NAT Gateway to reduce cost (true for dev/test, false for HA in prod)"
  type        = bool
  default     = true
}