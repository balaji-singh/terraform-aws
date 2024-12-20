# AWS WAF Module

This Terraform module creates an AWS WAF (Web Application Firewall) configuration with common security rules and protections.

## Features

- AWS WAFv2 Web ACL with configurable rules
- AWS Managed Rules (Common Rule Set and Known Bad Inputs)
- Configurable rate limiting rules
- IP-based rate limiting and blacklisting
- CloudWatch logging with field redaction
- Supports both REGIONAL and CLOUDFRONT deployments

## Usage

```hcl
module "waf" {
  source = "./modules/waf"

  name        = "my-application-waf"
  description = "WAF for my application"
  scope       = "REGIONAL"

  enable_rate_limiting = true
  rate_limit          = 2000
  
  ip_blacklist = ["1.2.3.4/32"]
  
  enable_logging     = true
  redacted_fields    = ["authorization", "cookie"]
  log_retention_days = 30

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.waf_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_wafv2_ip_set.blacklist](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_logging_configuration.waf_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the WAF Web ACL | `string` | `"WAF Web ACL"` | no |
| <a name="input_enable_logging"></a> [enable\_logging](#input\_enable\_logging) | Enable WAF logging | `bool` | `true` | no |
| <a name="input_enable_rate_limiting"></a> [enable\_rate\_limiting](#input\_enable\_rate\_limiting) | Enable rate limiting rule | `bool` | `true` | no |
| <a name="input_ip_blacklist"></a> [ip\_blacklist](#input\_ip\_blacklist) | List of IP addresses to block | `list(string)` | `[]` | no |
| <a name="input_ip_rate_limit"></a> [ip\_rate\_limit](#input\_ip\_rate\_limit) | Optional IP-based rate limit. Specify the maximum number of requests allowed from an IP in a 5-minute period | `number` | `null` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Number of days to retain WAF logs | `number` | `30` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the WAF Web ACL | `string` | n/a | yes |
| <a name="input_rate_limit"></a> [rate\_limit](#input\_rate\_limit) | The maximum number of requests from an IP address allowed in a 5-minute period | `number` | `2000` | no |
| <a name="input_redacted_fields"></a> [redacted\_fields](#input\_redacted\_fields) | List of fields to redact from logs | `list(string)` | <pre>[<br/>  "authorization",<br/>  "cookie"<br/>]</pre> | no |
| <a name="input_scope"></a> [scope](#input\_scope) | Scope of the WAF Web ACL. Valid values are REGIONAL or CLOUDFRONT | `string` | `"REGIONAL"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_blacklist_id"></a> [ip\_blacklist\_id](#output\_ip\_blacklist\_id) | The ID of the IP blacklist set |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | The ARN of the CloudWatch log group for WAF logs |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | The name of the CloudWatch log group for WAF logs |
| <a name="output_web_acl_arn"></a> [web\_acl\_arn](#output\_web\_acl\_arn) | The ARN of the WAF Web ACL |
| <a name="output_web_acl_capacity"></a> [web\_acl\_capacity](#output\_web\_acl\_capacity) | The capacity of the WAF Web ACL |
| <a name="output_web_acl_id"></a> [web\_acl\_id](#output\_web\_acl\_id) | The ID of the WAF Web ACL |
| <a name="output_web_acl_name"></a> [web\_acl\_name](#output\_web\_acl\_name) | The name of the WAF Web ACL |

## Security Features

### AWS Managed Rules
- **AWSManagedRulesCommonRuleSet**: Protection against common web exploits
- **AWSManagedRulesKnownBadInputsRuleSet**: Protection against known malicious inputs

### Rate Limiting
- Configurable rate limiting based on IP addresses
- Optional separate IP-based rate limiting rules
- IP blacklist capability for blocking specific addresses

### Logging and Monitoring
- CloudWatch logging with configurable retention
- Field redaction for sensitive data
- Metrics enabled for all rules

## License

Apache 2 Licensed. See LICENSE for full details.
