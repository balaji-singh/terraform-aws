output "db_instance_id" {
  description = "The RDS instance ID"
  value       = aws_db_instance.this.id
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.this.address
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.this.arn
}

output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = aws_db_subnet_group.this.id
}

output "db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = aws_db_subnet_group.this.arn
}

output "db_security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.this.id
}

output "db_security_group_arn" {
  description = "The ARN of the security group"
  value       = aws_security_group.this.arn
}
