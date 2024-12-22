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
  subnet_ids = dependency.vpc.outputs.private_subnet_ids

  node_group_size = {
    min     = local.node_groups.min
    max     = local.node_groups.max
    desired = local.node_groups.desired
  }

  tags = merge(local.tags, {
    Service = "EKS"
    Cluster = local.cluster_name
  })
}
