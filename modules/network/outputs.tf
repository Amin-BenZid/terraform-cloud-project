output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for k in sort(keys(aws_subnet.public)) : aws_subnet.public[k].id]
}

output "private_app_subnet_ids" {
  description = "List of private application subnet IDs"
  value       = [for k in sort(keys(aws_subnet.private_app)) : aws_subnet.private_app[k].id]
}

output "private_db_subnet_ids" {
  description = "List of private database subnet IDs"
  value       = [for k in sort(keys(aws_subnet.private_db)) : aws_subnet.private_db[k].id]
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = [for k in sort(keys(aws_nat_gateway.this)) : aws_nat_gateway.this[k].id]
}