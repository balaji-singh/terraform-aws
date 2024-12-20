# ---------------------------------------------------------------------------------------------------------------------
# AWS EKS Node Group
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  ami_type        = var.ami_type
  instance_types  = var.instance_types
  capacity_type   = var.capacity_type
  disk_size       = var.disk_size
  release_version = var.ami_release_version

  remote_access {
    ec2_ssh_key               = var.ec2_ssh_key
    source_security_group_ids = var.source_security_group_ids
  }

  labels = var.node_labels

  taint {
    key    = var.taint_key
    value  = var.taint_value
    effect = var.taint_effect
  }

  launch_template {
    name    = var.launch_template_name
    version = var.launch_template_version
  }

  update_config {
    max_unavailable = var.max_unavailable
  }

  tags = var.tags

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  depends_on = [var.module_depends_on]
}
