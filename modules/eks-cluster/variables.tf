# ---------------------------------------------------------------------------------------------------------------------
# Required Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Cluster Configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "kubernetes_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.27"
}

variable "enabled_cluster_log_types" {
  description = "List of the desired control plane logging to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Network Configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "endpoint_private_access" {
  description = "Whether the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "List of CIDR blocks that can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "security_group_ids" {
  description = "List of security group IDs for the EKS cluster"
  type        = list(string)
  default     = []
}

variable "service_ipv4_cidr" {
  description = "The CIDR block to assign Kubernetes service IP addresses from"
  type        = string
  default     = null
}

variable "ip_family" {
  description = "The IP family used to assign Kubernetes pod and service addresses. Valid values are ipv4 and ipv6"
  type        = string
  default     = "ipv4"
  validation {
    condition     = contains(["ipv4", "ipv6"], var.ip_family)
    error_message = "IP family must be either 'ipv4' or 'ipv6'."
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Encryption Configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "enable_cluster_encryption" {
  description = "Enable envelope encryption for cluster secrets"
  type        = bool
  default     = false
}

variable "cluster_encryption_key_arn" {
  description = "ARN of the KMS key used for cluster encryption"
  type        = string
  default     = null
}

variable "cluster_encryption_resources" {
  description = "List of resources to encrypt. Valid values are secrets"
  type        = list(string)
  default     = ["secrets"]
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Timeouts Configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_timeouts" {
  description = "Timeouts for EKS cluster operations"
  type = object({
    create = optional(string)
    delete = optional(string)
    update = optional(string)
  })
  default = null
}

variable "addon_timeouts" {
  description = "Timeouts for EKS add-ons"
  type = object({
    create = optional(string)
    delete = optional(string)
    update = optional(string)
  })
  default = null
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - EKS Configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "outpost_config" {
  description = "Configuration block for EKS cluster on Outposts"
  type = object({
    control_plane_instance_type = string
    outpost_arns                = list(string)
  })
  default = null
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Addons Configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_addons" {
  description = "List of EKS add-ons to enable"
  type = list(object({
    name                     = string
    version                  = optional(string)
    resolve_conflicts        = optional(string)
    service_account_role_arn = optional(string)
  }))
  default = []
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables - Tags
# ---------------------------------------------------------------------------------------------------------------------

variable "default_tags" {
  description = "A map of default tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on"
  type        = list(any)
  default     = []
}
