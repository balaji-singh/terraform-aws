terraform {
  source = "../modules//s3"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root_vars = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

inputs = {
  bucket_name                = "${local.root_vars.locals.account_name}-terraform-state"
  enable_versioning          = true
  create_dynamodb_lock_table = true
  dynamodb_table_name        = "${local.root_vars.locals.account_name}-terraform-locks"

  tags = {
    Environment = "global"
    ManagedBy   = "Terraform"
    Purpose     = "Terraform State Management"
  }
}

# Override provider configuration to use us-east-1
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = "us-east-1"  # Backend bucket must be in us-east-1
  
  default_tags {
    tags = {
      ManagedBy    = "Terraform"
      Organization = "${local.root_vars.locals.account_name}"
    }
  }
}
EOF
}
