# ---------------------------------------------------------------------------------------------------------------------
# EKS Node Group Outputs
# ---------------------------------------------------------------------------------------------------------------------

output "node_group_id" {
  description = "EKS node group ID"
  value       = aws_eks_node_group.main.id
}

output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = aws_eks_node_group.main.arn
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = aws_eks_node_group.main.status
}

output "node_group_resources" {
  description = "List of objects containing information about underlying resources of the EKS Node Group"
  value       = aws_eks_node_group.main.resources
}

output "node_group_scaling_config" {
  description = "Scaling configuration details of the EKS Node Group"
  value       = aws_eks_node_group.main.scaling_config
}

output "node_group_labels" {
  description = "Map of Kubernetes labels applied to the nodes"
  value       = aws_eks_node_group.main.labels
}

output "node_group_taints" {
  description = "List of Kubernetes taints applied to the nodes"
  value       = aws_eks_node_group.main.taint
}
