locals {
  tags = merge(
    var.tags,
    var.default_tags,
    {
      "terraform-module"    = "waf"
      "terraform-workspace" = terraform.workspace
    },
  )
}

resource "aws_wafv2_web_acl" "main" {
  name        = var.name
  description = var.description
  scope       = var.scope

  default_action {
    allow {}
  }

  # AWS Managed Rules - Common Rule Set
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  # AWS Managed Rules - Known Bad Inputs
  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  # Rate Limiting Rule
  dynamic "rule" {
    for_each = var.enable_rate_limiting ? [1] : []
    content {
      name     = "RateLimitRule"
      priority = 3

      action {
        block {}
      }

      statement {
        rate_based_statement {
          limit              = var.rate_limit
          aggregate_key_type = "IP"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "RateLimitRuleMetric"
        sampled_requests_enabled   = true
      }
    }
  }

  # IP Rate Limiting Rule
  dynamic "rule" {
    for_each = var.ip_rate_limit != null ? [1] : []
    content {
      name     = "IPRateLimitRule"
      priority = 4

      action {
        block {}
      }

      statement {
        rate_based_statement {
          limit              = var.ip_rate_limit
          aggregate_key_type = "IP"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "IPRateLimitRuleMetric"
        sampled_requests_enabled   = true
      }
    }
  }

  # IP Blacklist Rule
  dynamic "rule" {
    for_each = length(var.ip_blacklist) > 0 ? [1] : []
    content {
      name     = "IPBlacklistRule"
      priority = 5

      action {
        block {}
      }

      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.blacklist[0].arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "IPBlacklistRuleMetric"
        sampled_requests_enabled   = true
      }
    }
  }

  tags = local.tags

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name}-metric"
    sampled_requests_enabled   = true
  }
}

# IP Set for blacklisted IPs
resource "aws_wafv2_ip_set" "blacklist" {
  count              = length(var.ip_blacklist) > 0 ? 1 : 0
  name               = "${var.name}-blacklist"
  description        = "IP blacklist for ${var.name}"
  scope              = var.scope
  ip_address_version = "IPV4"
  addresses          = var.ip_blacklist

  tags = local.tags
}

# CloudWatch log group for WAF logs
resource "aws_cloudwatch_log_group" "waf_log_group" {
  count             = var.enable_logging ? 1 : 0
  name              = "/aws/waf/${var.name}"
  retention_in_days = var.log_retention_days

  tags = local.tags
}

# Logging configuration
resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  count                   = var.enable_logging ? 1 : 0
  log_destination_configs = [aws_cloudwatch_log_group.waf_log_group[0].arn]
  resource_arn            = aws_wafv2_web_acl.main.arn

  dynamic "redacted_fields" {
    for_each = var.redacted_fields
    content {
      single_header {
        name = redacted_fields.value
      }
    }
  }
}
