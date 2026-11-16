output "db_instance_id" {
  description = "Identifier of the RDS instance"
  value       = aws_db_instance.this.id
}

output "db_instance_endpoint" {
  description = "Connection endpoint (host:port) of the private RDS instance"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_address" {
  description = "Private DNS hostname of the RDS instance"
  value       = aws_db_instance.this.address
}

output "db_instance_port" {
  description = "Port on which the RDS instance accepts connections"
  value       = aws_db_instance.this.port
}

output "db_subnet_group_name" {
  description = "Name of the RDS DB Subnet Group"
  value       = aws_db_subnet_group.this.name
}