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
    vpc_cidr          = "10.0.0.0/16"
  }
}

locals {
  env_vars  = read_terragrunt_config("../env.hcl")
  root_vars = read_terragrunt_config(find_in_parent_folders("root.hcl"))

  environment       = local.env_vars.locals.environment
  rds_instance_type = local.env_vars.locals.rds_instance_type
  rds_config        = local.env_vars.locals.rds_config
  tags              = local.env_vars.locals.tags
  account_id        = local.root_vars.locals.account_id
}

terraform {
  source = "../../../modules//rds"
}

inputs = {
  identifier = "${local.environment}-db"

  engine            = local.rds_config.engine
  engine_version    = local.rds_config.engine_version
  instance_class    = local.rds_instance_type
  allocated_storage = 20

  db_name  = local.rds_config.db_name
  username = local.rds_config.username
  password = "DevPassword123$"  # Using only allowed special characters
  port     = 5432

  # VPC Configuration
  vpc_id              = dependency.vpc.outputs.vpc_id
  subnet_ids          = dependency.vpc.outputs.private_subnet_ids
  allowed_cidr_blocks = [dependency.vpc.outputs.vpc_cidr]

  # Maintenance Windows
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Multi-AZ and Storage
  multi_az               = false
  storage_type          = "gp3"
  max_allocated_storage = 100

  # Backup and Maintenance
  backup_retention_period = 7
  skip_final_snapshot    = true

  # Tags
  tags = merge(local.tags, {
    Service = "PostgreSQL"
  })
}
