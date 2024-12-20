locals {
  account_name   = "dev"
  aws_account_id = "166397132301" # Replace with your dev account ID

  # Common tags for this account
  common_tags = {
    Account     = "dev"
    Environment = "development"
    CostCenter  = "development"
  }
}
