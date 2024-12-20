# ---------------------------------------------------------------------------------------------------------------------
# Local Variables
# ---------------------------------------------------------------------------------------------------------------------

locals {
  cluster_name = "${var.project_name}-${var.environment}-eks"

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Terraform   = "true"
    Region      = var.aws_region
  }
}
