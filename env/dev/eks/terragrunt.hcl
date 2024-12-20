include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "common" {
  path = find_in_parent_folders("config/terragrunt-common.hcl")
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id          = "vpc-00000000"
    private_subnets = ["subnet-00000000", "subnet-11111111"]
    public_subnets  = ["subnet-22222222", "subnet-33333333"]
  }
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  environment     = local.env_vars.locals.environment
  cluster_name    = local.env_vars.locals.cluster_name
  cluster_version = local.env_vars.locals.cluster_version
  node_groups     = local.env_vars.locals.node_group_size
  tags            = local.env_vars.locals.tags
}

terraform {
  source = "../../../modules//eks"

  # Force dependency on VPC module
  after_hook "dep_check" {
    commands = ["init", "plan", "apply"]
    execute  = ["echo", "Checking VPC dependency..."]
  }
}

inputs = {
  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version

  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnets

  node_groups = {
    main = {
      desired_size = local.node_groups.desired
      max_size     = local.node_groups.max
      min_size     = local.node_groups.min

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      labels = {
        Environment = local.environment
        NodeGroup   = "main"
      }

      taints = []

      update_config = {
        max_unavailable_percentage = 50
      }
    }
  }

  # Enable IRSA
  enable_irsa = true

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Tags
  tags = merge(local.tags, {
    Service = "EKS"
    Cluster = local.cluster_name
  })
}
