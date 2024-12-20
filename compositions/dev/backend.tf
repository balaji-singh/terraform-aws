# ---------------------------------------------------------------------------------------------------------------------
# Terraform Backend Configuration
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  backend "s3" {
    bucket         = "terraform-state-eks-dev" # Change this to your state bucket
    key            = "dev/terraform.tfstate"
    region         = "us-west-2" # Change this to your desired region
    encrypt        = true
    dynamodb_table = "terraform-state-lock-eks-dev" # Change this to your lock table
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0"
}
