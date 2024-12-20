# ---------------------------------------------------------------------------------------------------------------------
# EKS Cluster Outputs
# ---------------------------------------------------------------------------------------------------------------------

output "cluster_id" {
  description = "The name/id of the EKS cluster"
  value       = aws_eks_cluster.main.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.main.arn
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_version" {
  description = "The Kubernetes version of the cluster"
  value       = aws_eks_cluster.main.version
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = aws_eks_cluster.main.role_arn
}

output "cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  value       = element(split("/", aws_eks_cluster.main.role_arn), 1)
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_status" {
  description = "Status of the EKS cluster"
  value       = aws_eks_cluster.main.status
}

output "cluster_platform_version" {
  description = "Platform version of the cluster"
  value       = aws_eks_cluster.main.platform_version
}

output "cluster_vpc_config" {
  description = "VPC configuration of the cluster"
  value = {
    endpoint_private_access = aws_eks_cluster.main.vpc_config[0].endpoint_private_access
    endpoint_public_access  = aws_eks_cluster.main.vpc_config[0].endpoint_public_access
    public_access_cidrs     = aws_eks_cluster.main.vpc_config[0].public_access_cidrs
    security_group_ids      = aws_eks_cluster.main.vpc_config[0].security_group_ids
    subnet_ids              = aws_eks_cluster.main.vpc_config[0].subnet_ids
  }
}

output "cluster_addons" {
  description = "Map of enabled cluster add-ons and their status"
  value = {
    for addon in aws_eks_addon.this : addon.addon_name => {
      addon_version = addon.addon_version
      status        = addon.status
    }
  }
}

output "identity_oidc_issuer" {
  description = "The OIDC Identity issuer for the cluster"
  value       = try(aws_eks_cluster.main.identity[0].oidc[0].issuer, null)
}

output "identity_oidc_issuer_arn" {
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account"
  value       = try(aws_eks_cluster.main.identity[0].oidc[0].issuer, null)
}

output "cluster_encryption_config" {
  description = "Encryption configuration for the cluster"
  value = var.enable_cluster_encryption ? {
    provider_key_arn = var.cluster_encryption_key_arn
    resources        = var.cluster_encryption_resources
  } : null
}
