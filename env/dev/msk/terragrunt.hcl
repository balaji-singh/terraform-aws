include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "common" {
  path = find_in_parent_folders("config/terragrunt-common.hcl")
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id             = "vpc-00000000"
    private_subnet_ids = ["subnet-00000000", "subnet-11111111"]
  }
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  environment = local.env_vars.locals.environment
  tags       = local.env_vars.locals.tags
}

terraform {
  source = "../../../modules//msk"
}

inputs = {
  cluster_name           = "${local.environment}-kafka"
  kafka_version         = "2.8.1"
  number_of_broker_nodes = 3
  broker_instance_type  = "kafka.t3.small"
  broker_volume_size    = 100

  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnet_ids

  auto_create_topics_enable     = false
  default_replication_factor    = 3
  min_insync_replicas          = 2
  num_partitions               = 3
  client_broker_encryption     = "TLS"
  log_retention_days           = 7

  tags = local.tags
}
