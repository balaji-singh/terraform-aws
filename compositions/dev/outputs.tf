# ---------------------------------------------------------------------------------------------------------------------
# VPC Outputs
# ---------------------------------------------------------------------------------------------------------------------

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnet_ids
}

# ---------------------------------------------------------------------------------------------------------------------
# EKS Cluster Outputs
# ---------------------------------------------------------------------------------------------------------------------

output "cluster_id" {
  description = "The name/id of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

# ---------------------------------------------------------------------------------------------------------------------
# EKS Node Group Outputs
# ---------------------------------------------------------------------------------------------------------------------

output "node_group_id" {
  description = "EKS node group ID"
  value       = module.eks.node_group_id
}

output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = module.eks.node_group_arn
}

# ---------------------------------------------------------------------------------------------------------------------
# Security Group Outputs
# ---------------------------------------------------------------------------------------------------------------------

output "cluster_security_group" {
  description = "ID of the EKS cluster security group"
  value       = module.security_groups.cluster_security_group_id
}

output "node_security_group" {
  description = "ID of the EKS node security group"
  value       = module.security_groups.node_security_group_id
}
