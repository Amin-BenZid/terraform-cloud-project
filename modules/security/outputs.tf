output "alb_security_group_id" {
  description = "Security Group ID for the Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "Security Group ID for the application EC2 instances"
  value       = aws_security_group.app.id
}

output "db_security_group_id" {
  description = "Security Group ID for the RDS database"
  value       = aws_security_group.db.id
}

output "ec2_instance_profile_name" {
  description = "IAM Instance Profile name attached to EC2 instances"
  value       = var.use_existing_lab_role ? data.aws_iam_instance_profile.existing[0].name : aws_iam_instance_profile.ec2[0].name
}