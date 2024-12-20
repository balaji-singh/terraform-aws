# ---------------------------------------------------------------------------------------------------------------------
# AWS EKS Cluster
# ---------------------------------------------------------------------------------------------------------------------

locals {
  tags = merge(
    var.tags,
    var.default_tags,
    {
      "terraform-module"    = "eks-cluster"
      "terraform-workspace" = terraform.workspace
    },
  )
}

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
    security_group_ids      = var.security_group_ids
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr
    ip_family         = var.ip_family
  }

  # Enable EKS cluster encryption
  dynamic "encryption_config" {
    for_each = var.enable_cluster_encryption ? [1] : []
    content {
      provider {
        key_arn = var.cluster_encryption_key_arn
      }
      resources = var.cluster_encryption_resources
    }
  }

  # Outpost configuration
  dynamic "outpost_config" {
    for_each = var.outpost_config != null ? [var.outpost_config] : []
    content {
      control_plane_instance_type = outpost_config.value.control_plane_instance_type
      outpost_arns                = outpost_config.value.outpost_arns
    }
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types

  timeouts {
    create = try(var.cluster_timeouts.create, null)
    update = try(var.cluster_timeouts.update, null)
    delete = try(var.cluster_timeouts.delete, null)
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  depends_on = [var.module_depends_on]

  tags = merge(
    {
      Name                                        = var.cluster_name
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    },
    local.tags
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS EKS Cluster Addons
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_eks_addon" "addons" {
  for_each = { for addon in var.cluster_addons : addon.name => addon }

  cluster_name             = aws_eks_cluster.main.name
  addon_name               = each.value.name
  addon_version            = each.value.version
  resolve_conflicts        = try(each.value.resolve_conflicts, "OVERWRITE")
  service_account_role_arn = try(each.value.service_account_role_arn, null)
  preserve                 = try(each.value.preserve, true)

  timeouts {
    create = try(var.addon_timeouts.create, null)
    update = try(var.addon_timeouts.update, null)
    delete = try(var.addon_timeouts.delete, null)
  }

  tags = merge(
    {
      "eks_addon" = each.value.name
    },
    local.tags
  )

  depends_on = [aws_eks_cluster.main]
}
