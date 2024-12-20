locals {
  # Account configuration - Replace with your actual values
  account_name = "dev"
  account_id   = "166397132301" # Replace with your AWS account ID
  aws_region   = "ap-south-1"

  # Common tags
  default_tags = {
    ManagedBy = "Terraform"
    Project   = "Infrastructure"
  }
}

# Configure remote state
remote_state {
  backend = "s3"

  config = {
    encrypt        = true
    bucket         = "terraform-state-${local.account_name}-${local.aws_region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "terraform-locks"

    s3_bucket_tags = merge(local.default_tags, {
      Purpose = "Terraform State"
    })

    dynamodb_table_tags = merge(local.default_tags, {
      Purpose = "Terraform State Locking"
    })
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Configure providers version constraints
generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}
EOF
}

# Configure global variables that all resources can inherit
inputs = {
  aws_region = local.aws_region
  account_id = local.account_id
  tags       = local.default_tags
}
