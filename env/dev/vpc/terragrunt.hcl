include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "common" {
  path = find_in_parent_folders("config/terragrunt-common.hcl")
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  vpc_cidr    = local.env_vars.locals.vpc_cidr
  azs         = local.env_vars.locals.azs
  environment = local.env_vars.locals.environment
  tags        = local.env_vars.locals.tags
}

terraform {
  source = "../../../modules//vpc"
}

inputs = {
  cluster_name = local.env_vars.locals.cluster_name
  vpc_cidr     = local.vpc_cidr

  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k + 3)]

  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tags required for EKS
  public_subnet_tags = merge(local.tags, {
    "kubernetes.io/role/elb" = "1"
    Environment              = local.environment
  })

  private_subnet_tags = merge(local.tags, {
    "kubernetes.io/role/internal-elb" = "1"
    Environment                       = local.environment
  })
}
