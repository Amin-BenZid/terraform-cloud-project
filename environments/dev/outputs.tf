output "alb_url" {
  description = "Public HTTP URL of the Application Load Balancer"
  value       = "http://${module.load_balancer.alb_dns_name}"
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.compute.autoscaling_group_name
}

output "db_instance_endpoint" {
  description = "Private RDS endpoint"
  value       = module.database.db_instance_endpoint
}

output "storage_bucket_name" {
  description = "Name of the S3 storage bucket"
  value       = module.storage.bucket_name
}