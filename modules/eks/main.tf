module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size = 50
  }

  eks_managed_node_groups = {
    general = {
      desired_size = var.node_group_size.desired
      min_size     = var.node_group_size.min
      max_size     = var.node_group_size.max

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      labels = {
        role = "general"
      }

      tags = var.tags
    }
  }

  tags = var.tags
}
