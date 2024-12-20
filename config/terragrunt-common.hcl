locals {
  # Load common config
  common_vars = yamldecode(file(find_in_parent_folders("config/common.yaml")))

  # Environment specific variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment      = local.environment_vars.locals.environment
  organization     = "YourCompany"
  aws_region       = local.environment_vars.locals.aws_region

  # Resource naming
  name_prefix = "${local.common_vars.resource_prefix}-${local.common_vars.environment_prefixes[local.environment]}"

  root_vars = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

# Generate provider configurations
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = "${local.root_vars.locals.aws_region}"
  
  default_tags {
    tags = {
      Environment     = "${local.environment}"
      ManagedBy      = "Terraform"
      Organization   = "${local.organization}"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
EOF
}

# Common inputs for all terragrunt configurations
inputs = {
  environment = local.environment
  name_prefix = local.name_prefix

  common_tags = merge(
    local.common_vars.common_tags,
    {
      Environment = local.environment
      Terraform   = "true"
      Project     = "infrastructure"
    }
  )
}

# Configure Terragrunt to use common remote state configuration
remote_state {
  backend = "s3"

  config = {
    encrypt        = true
    bucket         = "terraform-state-${local.root_vars.locals.account_name}-${local.root_vars.locals.aws_region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.root_vars.locals.aws_region
    dynamodb_table = "terraform-locks"

    s3_bucket_tags = {
      Environment = local.environment
      Terraform   = "true"
    }

    dynamodb_table_tags = {
      Environment = local.environment
      Terraform   = "true"
    }
  }
}

# Terragrunt hooks
terraform {
  before_hook "before_hook" {
    commands = ["apply", "plan"]
    execute  = ["echo", "Running Terraform"]
  }

  after_hook "after_hook" {
    commands     = ["apply", "plan"]
    execute      = ["echo", "Terraform execution completed"]
    run_on_error = true
  }
}

# Retry configuration for transient errors
retryable_errors = [
  "(?s).*Error creating.*",
  "(?s).*Error updating.*",
  "(?s).*Error deleting.*",
  "(?s).*RequestError: send request failed.*"
]

retry_max_attempts       = 3
retry_sleep_interval_sec = 5
