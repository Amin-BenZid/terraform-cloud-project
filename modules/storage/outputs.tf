output "bucket_name" {
  description = "Name of the S3 storage bucket"
  value       = local.bucket_name
}

output "bucket_arn" {
  description = "ARN of the S3 storage bucket"
  value       = "arn:aws:s3:::${local.bucket_name}"
}