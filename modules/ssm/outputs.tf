output "parameter_arns" {
  description = "ARNs of created parameters"
  value       = { for k, v in aws_ssm_parameter.parameter : k => v.arn }
}

output "parameter_names" {
  description = "Names of created parameters"
  value       = { for k, v in aws_ssm_parameter.parameter : k => v.name }
}

output "parameter_versions" {
  description = "Versions of created parameters"
  value       = { for k, v in aws_ssm_parameter.parameter : k => v.version }
}
