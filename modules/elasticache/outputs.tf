output "cluster_id" {
  description = "The ID of the ElastiCache cluster"
  value       = var.engine == "redis" ? aws_elasticache_replication_group.redis[0].id : aws_elasticache_cluster.memcached[0].id
}

output "cluster_address" {
  description = "The DNS name of the ElastiCache cluster without the port appended"
  value       = var.engine == "redis" ? aws_elasticache_replication_group.redis[0].primary_endpoint_address : aws_elasticache_cluster.memcached[0].cluster_address
}

output "cluster_port" {
  description = "The port number on which the cluster accepts connections"
  value       = var.port
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "The ARN of the security group"
  value       = aws_security_group.this.arn
}

output "parameter_group_id" {
  description = "The ID of the parameter group"
  value       = aws_elasticache_parameter_group.this.id
}

output "subnet_group_id" {
  description = "The ID of the subnet group"
  value       = aws_elasticache_subnet_group.this.id
}

output "engine" {
  description = "The cache engine used"
  value       = var.engine
}

output "engine_version" {
  description = "The cache engine version used"
  value       = var.engine_version
}
