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
    vpc_cidr_block  = "10.0.0.0/16"
  }
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  environment         = local.env_vars.locals.environment
  cache_instance_type = local.env_vars.locals.cache_instance_type
  cache_config        = local.env_vars.locals.cache_config
  tags                = local.env_vars.locals.tags
}

terraform {
  source = "../../../modules//elasticache"
}

inputs = {
  cluster_id      = "${local.environment}-redis"
  engine          = local.cache_config.engine
  engine_version  = local.cache_config.engine_version
  node_type       = local.cache_instance_type
  num_cache_nodes = local.cache_config.num_cache_nodes
  port            = 6379

  subnet_ids         = dependency.vpc.outputs.private_subnets
  security_group_ids = [] # Add security group IDs

  parameter_group_family = "redis7"

  # Enable Multi-AZ
  automatic_failover_enabled = true
  multi_az_enabled           = true

  # Maintenance window
  maintenance_window = "sun:05:00-sun:09:00"
  snapshot_window    = "03:00-05:00"

  # Backup retention
  snapshot_retention_limit = 7

  # Enable at-rest encryption
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  # Tags
  tags = merge(local.tags, {
    Service = "ElastiCache"
    Engine  = local.cache_config.engine
  })
}
