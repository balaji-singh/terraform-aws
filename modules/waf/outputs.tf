output "web_acl_id" {
  description = "The ID of the WAF Web ACL"
  value       = aws_wafv2_web_acl.main.id
}

output "web_acl_arn" {
  description = "The ARN of the WAF Web ACL"
  value       = aws_wafv2_web_acl.main.arn
}

output "web_acl_capacity" {
  description = "The capacity of the WAF Web ACL"
  value       = aws_wafv2_web_acl.main.capacity
}

output "web_acl_name" {
  description = "The name of the WAF Web ACL"
  value       = aws_wafv2_web_acl.main.name
}

output "ip_blacklist_id" {
  description = "The ID of the IP blacklist set"
  value       = try(aws_wafv2_ip_set.blacklist[0].id, null)
}

output "log_group_name" {
  description = "The name of the CloudWatch log group for WAF logs"
  value       = try(aws_cloudwatch_log_group.waf_log_group[0].name, null)
}

output "log_group_arn" {
  description = "The ARN of the CloudWatch log group for WAF logs"
  value       = try(aws_cloudwatch_log_group.waf_log_group[0].arn, null)
}
