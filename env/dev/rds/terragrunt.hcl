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
  port     = 5432

  vpc_security_group_ids = [] # Add security group IDs
  subnet_ids             = dependency.vpc.outputs.private_subnets

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Backups
  backup_retention_period = 7
  skip_final_snapshot     = true

  # Enhanced Monitoring
  monitoring_interval = 60
  monitoring_role_arn = "arn:aws:iam::${local.account_id}:role/rds-monitoring-role"

  # DB subnet group
  create_db_subnet_group = true

  # DB parameter group
  family = "postgres14"

  # DB option group
  major_engine_version = "14"

  # Multi AZ
  multi_az = false # Set to true for production

  # Tags
  tags = merge(local.tags, {
    Service = "RDS"
    Engine  = local.rds_config.engine
  })
}
