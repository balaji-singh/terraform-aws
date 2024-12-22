resource "aws_ssm_parameter" "parameter" {
  for_each = var.parameters

  name        = "/${var.environment}/${var.service}/${each.key}"
  description = each.value.description
  type        = each.value.type
  value       = each.value.value
  tier        = try(each.value.tier, "Standard")

  tags = merge(
    var.tags,
    var.default_tags,
    {
      "terraform-module" = "ssm"
      Name               = "/${var.environment}/${var.service}/${each.key}"
    }
  )
}
