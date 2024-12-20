# ---------------------------------------------------------------------------------------------------------------------
# Required Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  description = "Name of the EKS cluster - used for tagging resources"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC Configuration Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "CIDR block for the VPC network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = <<-EOT
    List of CIDR blocks for public subnets. 
    Should be one per AZ for high availability.
    Example: ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  EOT
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = <<-EOT
    List of CIDR blocks for private subnets.
    Should be one per AZ for high availability.
    Example: ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  EOT
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "enable_ipv6" {
  description = "Enable IPv6 support for VPC"
  type        = bool
  default     = false
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC"
  type        = bool
  default     = false
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "default_tags" {
  description = "A map of default tags to add to all resources"
  type        = map(string)
  default     = {}
}
