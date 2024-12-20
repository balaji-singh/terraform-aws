include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "common" {
  path = find_in_parent_folders("config/terragrunt-common.hcl")
}

locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment = local.env_vars.locals.environment
  tags        = local.env_vars.locals.tags
}

terraform {
  source = "../../../modules//waf"
}

inputs = {
  name        = "${local.environment}-waf"
  description = "WAF rules for ${local.environment} environment"

  # WAF Scope (REGIONAL or CLOUDFRONT)
  scope = "REGIONAL"

  # Enable rate limiting
  enable_rate_limiting = true
  rate_limit           = 2000 # requests per 5 minutes

  # IP rate limiting
  ip_rate_limit = 1000

  # Enable logging
  enable_logging     = true
  log_retention_days = 30

  # Fields to redact from logs
  redacted_fields = ["authorization", "cookie"]

  # Common tags
  tags = merge(local.tags, {
    Service = "WAF"
  })

  # IP blacklist
  ip_blacklist = [] # Add IPs to block
}
