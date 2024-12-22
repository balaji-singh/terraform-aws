include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "common" {
  path = find_in_parent_folders("config/terragrunt-common.hcl")
}

locals {
  env_vars = read_terragrunt_config("../env.hcl")

  environment = local.env_vars.locals.environment
  rds_config  = local.env_vars.locals.rds_config
  tags        = local.env_vars.locals.tags
}

terraform {
  source = "../../../modules//ssm"
}

inputs = {
  environment = local.environment
  service     = "rds"

  parameters = {
    "username" = {
      description = "RDS master username"
      type        = "String"
      value       = local.rds_config.username
    }
    "password" = {
      description = "RDS master password"
      type        = "SecureString"
      value       = "DevPassword123$" # In production, use a more secure way to generate passwords
    }
  }

  tags = local.tags
}
