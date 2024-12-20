# ---------------------------------------------------------------------------------------------------------------------
# AWS Provider Configuration
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "dev"
      Terraform   = "true"
      Project     = var.project_name
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Module
# ---------------------------------------------------------------------------------------------------------------------

module "vpc" {
  source = "../../modules/vpc"

  cluster_name = local.cluster_name
  vpc_cidr     = var.vpc_cidr

  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  tags = local.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# Security Groups Module
# ---------------------------------------------------------------------------------------------------------------------

module "security_groups" {
  source = "../../modules/security-groups"

  cluster_name = local.cluster_name
  vpc_id       = module.vpc.vpc_id

  allowed_cidr_blocks = var.allowed_cidr_blocks

  tags = local.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# IAM Roles Module
# ---------------------------------------------------------------------------------------------------------------------

module "iam_roles" {
  source = "../../modules/iam-roles"

  cluster_name = local.cluster_name
  tags         = local.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# EKS Cluster Module
# ---------------------------------------------------------------------------------------------------------------------

module "eks_cluster" {
  source = "../../modules/eks-cluster"

  cluster_name       = local.cluster_name
  cluster_role_arn   = module.iam_roles.cluster_role_arn
  kubernetes_version = var.kubernetes_version

  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.security_groups.cluster_security_group_id]

  endpoint_private_access = var.endpoint_private_access
  endpoint_public_access  = var.endpoint_public_access

  enabled_cluster_log_types = var.enabled_cluster_log_types

  tags = local.tags

  module_depends_on = [
    module.vpc,
    module.security_groups,
    module.iam_roles
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# EKS Node Group Module
# ---------------------------------------------------------------------------------------------------------------------

module "eks_node_group" {
  source = "../../modules/eks-node-group"

  cluster_name    = module.eks_cluster.cluster_id
  node_group_name = "${local.cluster_name}-node-group"
  node_role_arn   = module.iam_roles.node_role_arn
  subnet_ids      = module.vpc.private_subnet_ids

  # Scaling configuration
  desired_size = var.node_desired_size
  max_size     = var.node_max_size
  min_size     = var.node_min_size

  # Node configuration
  instance_types = var.node_instance_types
  disk_size      = var.node_disk_size
  capacity_type  = var.capacity_type

  # Labels
  node_labels = merge(
    {
      "eks.amazonaws.com/nodegroup" = "${local.cluster_name}-node-group"
    },
    var.node_labels
  )

  tags = local.tags

  module_depends_on = [
    module.eks_cluster
  ]
}
