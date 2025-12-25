output "db_instance_identifier" {
  description = "RDS instance identifier."
  value       = aws_db_instance.this.identifier
}

output "endpoint" {
  description = "RDS instance endpoint."
  value       = aws_db_instance.this.endpoint
}

output "port" {
  description = "RDS instance port."
  value       = aws_db_instance.this.port
}

output "security_group_id" {
  description = "Security group ID for the RDS instance."
  value       = aws_security_group.this.id
}

output "subnet_group_name" {
  description = "DB subnet group name."
  value       = aws_db_subnet_group.this.name
}
