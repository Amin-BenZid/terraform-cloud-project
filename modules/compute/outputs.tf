output "launch_template_id" {
  description = "ID of the application Launch Template"
  value       = aws_launch_template.app.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}

output "autoscaling_group_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.app.arn
}

output "ami_id" {
  description = "Amazon Linux 2023 AMI ID selected for instances"
  value       = data.aws_ami.al2023.id
}